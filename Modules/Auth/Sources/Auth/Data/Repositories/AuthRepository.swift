//
//  File.swift
//  
//
//  Created by Ahmed Elkady on 27/06/2026.
//

import Foundation

public final class AuthRepository: AuthRepositoryProtocol {

    private let firebaseDataSource: FirebaseAuthDataSource
    private let googleDataSource: GoogleSignInDataSource
    private let shopifyDataSource: ShopifyCustomerDataSource
    private let sessionLocalDataSource: SessionLocalDataSource
    private let keychainDataSource: KeychainDataSource

    public convenience init() {
        self.init(
            firebaseDataSource: FirebaseAuthDataSource(),
            googleDataSource: GoogleSignInDataSource(),
            shopifyDataSource: ShopifyCustomerDataSource(),
            sessionLocalDataSource: SessionLocalDataSource(),
            keychainDataSource: KeychainDataSource()
        )
    }

    init(
        firebaseDataSource: FirebaseAuthDataSource = .init(),
        googleDataSource: GoogleSignInDataSource = .init(),
        shopifyDataSource: ShopifyCustomerDataSource = .init(),
        sessionLocalDataSource: SessionLocalDataSource = .init(),
        keychainDataSource: KeychainDataSource = .init()
    ) {
        self.firebaseDataSource = firebaseDataSource
        self.googleDataSource = googleDataSource
        self.shopifyDataSource = shopifyDataSource
        self.sessionLocalDataSource = sessionLocalDataSource
        self.keychainDataSource = keychainDataSource
    }

    public func signIn(email: String, password: String) async -> Result<Session, AuthError> {
        do {
            let user = try await firebaseDataSource.signIn(email: email, password: password)
            let session = try await shopifyDataSource.createAccessToken(
                credentials: ShopifyCustomerCredentials(email: email, password: password),
                firebaseUID: user.uid
            )
            try sessionLocalDataSource.save(session)
            return .success(session)
        } catch {
            return .failure(mapError(error))
        }
    }

    public func signUp(email: String, password: String, firstName: String, lastName: String) async -> Result<Session, AuthError> {
        do {
            let user = try await firebaseDataSource.signUp(
                email: email,
                password: password,
                firstName: firstName,
                lastName: lastName
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
            return .success(session)
        } catch {
            sessionLocalDataSource.clear()
            return .failure(mapError(error))
        }
    }

    public func signInWithSocial(provider: AuthProvider) async -> Result<SocialSignInResult, AuthError> {
        guard provider == .google else {
            return .failure(.authentication("Apple sign-in is not implemented yet."))
        }

        do {
            let socialUser = try await googleDataSource.signIn()
            guard let savedPassword = keychainDataSource.password(for: socialUser.email) else {
                return .success(.newUser(
                    email: socialUser.email,
                    displayName: socialUser.displayName,
                    provider: provider
                ))
            }

            let session = try await shopifyDataSource.createAccessToken(
                credentials: ShopifyCustomerCredentials(email: socialUser.email, password: savedPassword),
                firebaseUID: socialUser.authUser.uid
            )
            try sessionLocalDataSource.save(session)
            return .success(.existingUser(session))
        } catch {
            return .failure(mapError(error))
        }
    }

    public func setPasswordForSocialUser(email: String, password: String, firstName: String, lastName: String) async -> Result<Session, AuthError> {
        do {
            guard let currentUser = firebaseDataSource.currentUser else {
                throw AuthError.authentication("Social sign-in session expired. Please try again.")
            }

            do {
                // Attempt to create a new Shopify customer account
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
                return .success(session)

            } catch AuthError.shopify(let message)
                where message.localizedCaseInsensitiveContains("already been taken")
                   || message.localizedCaseInsensitiveContains("already exists") {

                // MARK: Keychain-lost fallback (AGENT_Auth.md §known-case)
                // The Shopify customer already exists (e.g. app was reinstalled and
                // Keychain was wiped). We cannot set a new password via customerCreate.
                // Fall back to customerRecover so the user gets a Shopify reset-password
                // email — they can then log in normally with email+password.
                try? await shopifyDataSource.recoverPassword(email: email)
                return .failure(.shopify(
                    "An account with this email already exists. " +
                    "We've sent a password reset link to \(email). " +
                    "Please check your inbox, reset your password, then sign in with email and password."
                ))
            }
        } catch {
            sessionLocalDataSource.clear()
            return .failure(mapError(error))
        }
    }

    public func signOut() async -> Result<Void, AuthError> {
        do {
            if let session = sessionLocalDataSource.fetch(), session.isValid {
                try await shopifyDataSource.deleteAccessToken(session.customerAccessToken)
            }
            try firebaseDataSource.signOut()
            sessionLocalDataSource.clear()
            return .success(())
        } catch {
            return .failure(mapError(error))
        }
    }

    public func recoverPassword(email: String) async -> Result<Void, AuthError> {
        do {
            try await shopifyDataSource.recoverPassword(email: email)
            return .success(())
        } catch {
            return .failure(mapError(error))
        }
    }

    public func currentSession() -> Session? {
        sessionLocalDataSource.fetch()
    }

    private func mapError(_ error: Error) -> AuthError {
        if let authError = error as? AuthError {
            return authError
        }

        if let localizedError = error as? LocalizedError,
           let message = localizedError.errorDescription,
           !message.isEmpty {
            return .authentication(message)
        }

        return .authentication(error.localizedDescription)
    }
}
