//
//  AuthRepository.swift
//

import Foundation
import Common

public final class AuthRepository: AuthRepositoryProtocol {

    private let firebaseDataSource: FirebaseAuthDataSource
    private let googleDataSource: GoogleSignInDataSource
    private let shopifyRESTDataSource: ShopifyCustomerRESTDataSource
    private let shopifyGraphQLDataSource: ShopifyCustomerDataSource // Keep for Storefront access tokens
    private let sessionLocalDataSource: SessionLocalDataSource
    private let sessionStore: SessionProviding

    public convenience init() {
        fatalError("Use DI-injected initializer with SessionStore")
    }

    init(
        firebaseDataSource: FirebaseAuthDataSource = .init(),
        googleDataSource: GoogleSignInDataSource = .init(),
        shopifyRESTDataSource: ShopifyCustomerRESTDataSource = .init(),
        shopifyGraphQLDataSource: ShopifyCustomerDataSource = .init(),
        sessionLocalDataSource: SessionLocalDataSource = .init(),
        sessionStore: SessionProviding
    ) {
        self.firebaseDataSource       = firebaseDataSource
        self.googleDataSource         = googleDataSource
        self.shopifyRESTDataSource    = shopifyRESTDataSource
        self.shopifyGraphQLDataSource = shopifyGraphQLDataSource
        self.sessionLocalDataSource   = sessionLocalDataSource
        self.sessionStore             = sessionStore
    }

    // MARK: - Email / Password

    public func signIn(email: String, password: String) async -> Result<Session, AuthError> {
        do {
            // 1. Authenticate with Firebase
            let user = try await firebaseDataSource.signIn(email: email, password: password)
            
            // 2. Find Shopify customer by email (REST API)
            guard let customerId = try await shopifyRESTDataSource.findCustomerByEmail(email) else {
                throw AuthError.shopify("Customer account not found. Please register first.")
            }
            
            // 3. Create Storefront access token using Firebase UID as password
            // This is needed for cart, favorites, and other Storefront API operations
            let storefrontPassword = deriveStorefrontPassword(uid: user.uid)
            try await shopifyRESTDataSource.updateCustomerPassword(
                customerId: customerId,
                password: storefrontPassword
            )
            let tempSession = try await createStorefrontAccessToken(
                email: email,
                password: storefrontPassword,
                firebaseUID: user.uid
            )
            
            // 4. Create final session with both customer ID and access token
            let session = Session(
                customerAccessToken: tempSession.customerAccessToken,
                expiresAt: tempSession.expiresAt,
                customerId: customerId,
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
        // Note: This method is now only for sending verification email
        // Actual account creation happens after email verification
        do {
            // Create Firebase user
            let user = try await firebaseDataSource.signUp(
                email: email, password: password,
                firstName: firstName, lastName: lastName
            )
            
            // Send verification email
            try await firebaseDataSource.sendVerificationEmail()
            
            // Return temporary session (not saved yet - waiting for email verification)
            let tempSession = Session(
                customerAccessToken: "",
                expiresAt: Date.distantFuture,
                customerId: nil,
                firebaseUID: user.uid
            )
            
            return .success(tempSession)
        } catch {
            return .failure(mapError(error))
        }
    }
    
    /// Complete registration after email verification
    /// Called when user clicks verification link in email
    public func completeRegistrationAfterVerification(
        email: String,
        firstName: String,
        lastName: String,
        firebaseUID: String
    ) async -> Result<Session, AuthError> {
        do {
            // 1. Create or update the Shopify customer with the Storefront password.
            let storefrontPassword = deriveStorefrontPassword(uid: firebaseUID)
            let customerId: String
            if let existingCustomerId = try await shopifyRESTDataSource.findCustomerByEmail(email) {
                customerId = existingCustomerId
                try await shopifyRESTDataSource.updateCustomerPassword(
                    customerId: existingCustomerId,
                    password: storefrontPassword
                )
            } else {
                customerId = try await shopifyRESTDataSource.createCustomer(
                    email: email,
                    firstName: firstName,
                    lastName: lastName,
                    password: storefrontPassword,
                    verifiedEmail: true
                )
            }

            // 2. Create Storefront access token for cart/favorites operations.
            let accessTokenSession = try await createStorefrontAccessToken(
                email: email,
                password: storefrontPassword,
                firebaseUID: firebaseUID
            )
            
            // 3. Create and save full session
            let session = Session(
                customerAccessToken: accessTokenSession.customerAccessToken,
                expiresAt: accessTokenSession.expiresAt,
                customerId: customerId,
                firebaseUID: firebaseUID
            )
            
            try sessionLocalDataSource.save(session)
            updateSessionStore(session)
            
            return .success(session)
        } catch {
            return .failure(mapError(error))
        }
    }

    // MARK: - Google Sign-In (no password required with REST API for customer creation)

    public func signInWithSocial(provider: AuthProvider) async -> Result<SocialSignInResult, AuthError> {
        guard provider == .google else {
            return .failure(.authentication("Apple sign-in is not implemented yet."))
        }

        do {
            let socialUser = try await googleDataSource.signIn()
            let uid        = socialUser.authUser.uid
            let email      = socialUser.email

            // Check if Shopify customer exists (REST)
            if let customerId = try await shopifyRESTDataSource.findCustomerByEmail(email) {
                // Existing customer - create Storefront access token
                let storefrontPassword = deriveStorefrontPassword(uid: uid)
                try await shopifyRESTDataSource.updateCustomerPassword(
                    customerId: customerId,
                    password: storefrontPassword
                )
                let accessTokenSession = try await createStorefrontAccessToken(
                    email: email,
                    password: storefrontPassword,
                    firebaseUID: uid
                )
                
                let session = Session(
                    customerAccessToken: accessTokenSession.customerAccessToken,
                    expiresAt: accessTokenSession.expiresAt,
                    customerId: customerId,
                    firebaseUID: uid
                )
                try sessionLocalDataSource.save(session)
                updateSessionStore(session)
                return .success(.existingUser(session))
            }

            // New customer - create via REST (no password), then get Storefront access token
            let nameParts = (socialUser.displayName ?? "").components(separatedBy: " ")
            let firstName = nameParts.first ?? "User"
            let lastName  = nameParts.dropFirst().joined(separator: " ")

            let customerId = try await shopifyRESTDataSource.createCustomer(
                email: email,
                firstName: firstName,
                lastName: lastName.isEmpty ? firstName : lastName,
                password: deriveStorefrontPassword(uid: uid),
                verifiedEmail: true // Google accounts are pre-verified
            )
            
            // Create Storefront access token for this new customer
            let storefrontPassword = deriveStorefrontPassword(uid: uid)
            let accessTokenSession = try await createStorefrontAccessToken(
                email: email,
                password: storefrontPassword,
                firebaseUID: uid
            )
            
            let session = Session(
                customerAccessToken: accessTokenSession.customerAccessToken,
                expiresAt: accessTokenSession.expiresAt,
                customerId: customerId,
                firebaseUID: uid
            )
            try sessionLocalDataSource.save(session)
            updateSessionStore(session)
            return .success(.newUser(session))

        } catch {
            return .failure(mapError(error))
        }
    }

    // MARK: - Sign Out

    public func signOut() async -> Result<Void, AuthError> {
        do {
            // Delete Storefront access token if exists
            if let session = sessionLocalDataSource.fetch(), session.isValid,
               !session.customerAccessToken.isEmpty {
                try? await shopifyGraphQLDataSource.deleteAccessToken(session.customerAccessToken)
            }
            // Sign out from Firebase
            try firebaseDataSource.signOut()
            sessionLocalDataSource.clear()
            clearSessionStore()
            return .success(())
        } catch {
            return .failure(mapError(error))
        }
    }

    // MARK: - Password Recovery (Firebase only - Shopify REST doesn't manage passwords)

    public func recoverPassword(email: String) async -> Result<Void, AuthError> {
        do {
            // Send Firebase password reset email
            try await firebaseDataSource.sendPasswordReset(email: email)
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
    
    /// Derives a deterministic Storefront API password from Firebase UID
    /// This is used ONLY for creating Storefront access tokens (not stored in REST Admin API)
    /// Same UID → same password → consistent access tokens across devices
    private func deriveStorefrontPassword(uid: String) -> String {
        "Mx9!" + uid
    }
    
    /// Creates a Storefront API access token using GraphQL
    /// Required for cart, favorites, and other customer-specific Storefront operations
    private func createStorefrontAccessToken(
        email: String,
        password: String,
        firebaseUID: String
    ) async throws -> Session {
        try await shopifyGraphQLDataSource.createAccessToken(
            credentials: ShopifyCustomerCredentials(email: email, password: password),
            firebaseUID: firebaseUID
        )
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
