//
//  AuthRepository.swift
//

import Foundation
import Common

public final class AuthRepository: AuthRepositoryProtocol {

    private let firebaseDataSource: FirebaseAuthDataSource
    private let googleDataSource: GoogleSignInDataSource
    private let shopifyDataSource: ShopifyCustomerDataSource
    private let sessionLocalDataSource: SessionLocalDataSource
    private let keychainDataSource: KeychainDataSource
    private let sessionStore: SessionProviding

    public convenience init() {
        fatalError("Use DI-injected initializer with SessionStore")
    }

    init(
        firebaseDataSource: FirebaseAuthDataSource = .init(),
        googleDataSource: GoogleSignInDataSource = .init(),
        shopifyDataSource: ShopifyCustomerDataSource = .init(),
        sessionLocalDataSource: SessionLocalDataSource = .init(),
        keychainDataSource: KeychainDataSource = .init(),
        sessionStore: SessionProviding
    ) {
        self.firebaseDataSource     = firebaseDataSource
        self.googleDataSource       = googleDataSource
        self.shopifyDataSource      = shopifyDataSource
        self.sessionLocalDataSource = sessionLocalDataSource
        self.keychainDataSource     = keychainDataSource
        self.sessionStore           = sessionStore
    }

    // MARK: - Email / Password

    public func signIn(email: String, password: String) async -> Result<Session, AuthError> {
        do {
            let user    = try await firebaseDataSource.signIn(email: email, password: password)
            let session = try await shopifyDataSource.createAccessToken(
                credentials: ShopifyCustomerCredentials(email: email, password: password),
                firebaseUID: user.uid
            )
            try sessionLocalDataSource.save(session)
            updateSessionStore(session)
            return .success(session)
        } catch {
            return .failure(mapError(error))
        }
    }

    public func signUp(email: String, password: String, firstName: String, lastName: String) async -> Result<Session, AuthError> {
        do {
            let user = try await firebaseDataSource.signUp(
                email: email, password: password,
                firstName: firstName, lastName: lastName
            )
            try await firebaseDataSource.sendVerificationEmail()
            let customerId = try await shopifyDataSource.createCustomer(
                credentials: ShopifyCustomerCredentials(email: email, password: password),
                name: ShopifyCustomerName(firstName: firstName, lastName: lastName)
            )
            let session = try await shopifyDataSource.createAccessToken(
                credentials: ShopifyCustomerCredentials(email: email, password: password),
                firebaseUID: user.uid,
                customerId: customerId
            )
            try sessionLocalDataSource.save(session)
            updateSessionStore(session)
            return .success(session)
        } catch {
            sessionLocalDataSource.clear()
            clearSessionStore()
            return .failure(mapError(error))
        }
    }

    // MARK: - Google Sign-In (deterministic password — no keychain dependency)

    public func signInWithSocial(provider: AuthProvider) async -> Result<SocialSignInResult, AuthError> {
        guard provider == .google else {
            return .failure(.authentication("Apple sign-in is not implemented yet."))
        }

        do {
            let socialUser = try await googleDataSource.signIn()
            let uid        = socialUser.authUser.uid
            let email      = socialUser.email

            // Derive a deterministic Shopify password from the Firebase UID.
            // Same Google account → same password on every device/reinstall.
            // The user never sees or types this password.
            let derivedPassword = deriveShopifyPassword(uid: uid)
            let credentials     = ShopifyCustomerCredentials(email: email, password: derivedPassword)

            // 1. Happy path: account already exists with the derived password
            if let session = try? await shopifyDataSource.createAccessToken(
                credentials: credentials, firebaseUID: uid
            ) {
                try sessionLocalDataSource.save(session)
                updateSessionStore(session)
                return .success(.existingUser(session))
            }

            // 2. No token → try creating a new Shopify customer account
            let nameParts = (socialUser.displayName ?? "").components(separatedBy: " ")
            let firstName = nameParts.first ?? "User"
            let lastName  = nameParts.dropFirst().joined(separator: " ")

            do {
                _ = try await shopifyDataSource.createCustomer(
                    credentials: credentials,
                    name: ShopifyCustomerName(
                        firstName: firstName,
                        lastName: lastName.isEmpty ? firstName : lastName
                    )
                )
                let session = try await shopifyDataSource.createAccessToken(
                    credentials: credentials, firebaseUID: uid
                )
                try sessionLocalDataSource.save(session)
                updateSessionStore(session)
                return .success(.existingUser(session))

            } catch AuthError.shopify(let msg)
                where msg.localizedCaseInsensitiveContains("already")
                   || msg.localizedCaseInsensitiveContains("taken") {

                // 3. Account exists but with a different password (old manual SetPasswordView flow).
                //    Try keychain as a migration fallback.
                if let savedPwd = keychainDataSource.password(for: email),
                   let session  = try? await shopifyDataSource.createAccessToken(
                       credentials: ShopifyCustomerCredentials(email: email, password: savedPwd),
                       firebaseUID: uid
                   ) {
                    try sessionLocalDataSource.save(session)
                    updateSessionStore(session)
                    return .success(.existingUser(session))
                }

                // 4. Dead-end: account exists with an unknown password.
                return .failure(.shopify(
                    "This Google account is linked to an existing account with a manually set password. " +
                    "Please sign in using your email and that password instead."
                ))
            }
        } catch {
            return .failure(mapError(error))
        }
    }

    // MARK: - Set Password (kept for other social providers / edge cases)

    public func setPasswordForSocialUser(email: String, password: String, firstName: String, lastName: String) async -> Result<Session, AuthError> {
        do {
            guard let currentUser = firebaseDataSource.currentUser else {
                throw AuthError.authentication("Social sign-in session expired. Please try again.")
            }

            do {
                let customerId = try await shopifyDataSource.createCustomer(
                    credentials: ShopifyCustomerCredentials(email: email, password: password),
                    name: ShopifyCustomerName(firstName: firstName, lastName: lastName)
                )
                let session = try await shopifyDataSource.createAccessToken(
                    credentials: ShopifyCustomerCredentials(email: email, password: password),
                    firebaseUID: currentUser.uid,
                    customerId: customerId
                )
                try keychainDataSource.savePassword(password, for: email)
                try sessionLocalDataSource.save(session)
                updateSessionStore(session)
                return .success(session)

            } catch AuthError.shopify(let message)
                where message.localizedCaseInsensitiveContains("already been taken")
                   || message.localizedCaseInsensitiveContains("already exists") {

                try? await shopifyDataSource.recoverPassword(email: email)
                return .failure(.shopify(
                    "An account with this email already exists. " +
                    "We've sent a password reset link to \(email). " +
                    "Please check your inbox, reset your password, then sign in with email and password."
                ))
            }
        } catch {
            sessionLocalDataSource.clear()
            clearSessionStore()
            return .failure(mapError(error))
        }
    }

    // MARK: - Sign Out

    public func signOut() async -> Result<Void, AuthError> {
        do {
            if let session = sessionLocalDataSource.fetch(), session.isValid {
                try await shopifyDataSource.deleteAccessToken(session.customerAccessToken)
            }
            try firebaseDataSource.signOut()
            sessionLocalDataSource.clear()
            clearSessionStore()
            return .success(())
        } catch {
            return .failure(mapError(error))
        }
    }

    // MARK: - Password Recovery

    public func recoverPassword(email: String) async -> Result<Void, AuthError> {
        do {
            try await shopifyDataSource.recoverPassword(email: email)
            return .success(())
        } catch {
            return .failure(mapError(error))
        }
    }

    // MARK: - Current Session

    public func currentSession() -> Session? {
        sessionLocalDataSource.fetch()
    }

    // MARK: - Helpers

    /// Derives a deterministic Shopify password from a Firebase UID.
    /// "Mx9!" prefix meets Shopify's character-variety requirements.
    /// Firebase UIDs are 28-char alphanumeric → total 32 chars.
    private func deriveShopifyPassword(uid: String) -> String {
        "Mx9!" + uid
    }

    private func updateSessionStore(_ session: Session) {
        if let store = sessionStore as? SessionStore {
            store.updateSession(session.toCommonSession())
        }
    }

    private func clearSessionStore() {
        if let store = sessionStore as? SessionStore {
            store.clearSession()
        }
    }

    private func mapError(_ error: Error) -> AuthError {
        if let authError = error as? AuthError { return authError }
        if let localizedError = error as? LocalizedError,
           let message = localizedError.errorDescription,
           !message.isEmpty {
            return .authentication(message)
        }
        return .authentication(error.localizedDescription)
    }
}
