//
//  File.swift
//  
//
//  Created by Ahmed Elkady on 27/06/2026.
//

import Foundation

@available(iOS 13.0.0, *)
public final class AuthRepository: AuthRepositoryInterface {

    private let firebaseDataSource: FirebaseAuthDataSource
    private let googleDataSource: GoogleSignInDataSource
    private let shopifyDataSource: ShopifyAuthDataSource

    public convenience init() {
        self.init(
            firebaseDataSource: FirebaseAuthDataSource(),
            googleDataSource: GoogleSignInDataSource(),
            shopifyDataSource: ShopifyAuthDataSource()
        )
    }

    init(
        firebaseDataSource: FirebaseAuthDataSource = .init(),
        googleDataSource: GoogleSignInDataSource = .init(),
        shopifyDataSource: ShopifyAuthDataSource = .init()
    ) {
        self.firebaseDataSource = firebaseDataSource
        self.googleDataSource = googleDataSource
        self.shopifyDataSource = shopifyDataSource
    }

    public func login(email: String, password: String) async throws -> AuthUser {
        var user = try await firebaseDataSource.login(email: email, password: password)
        if let userEmail = user.email {
            let shopifyId = try? await shopifyDataSource.syncUser(email: userEmail, firstName: user.displayName, lastName: nil)
            user.shopifyCustomerID = shopifyId
        }
        return user
    }

    public func register(email: String, password: String, name: String) async throws -> AuthUser {
        var user = try await firebaseDataSource.register(email: email, password: password, name: name)
        let nameParts = name.split(separator: " ")
        let firstName = String(nameParts.first ?? "")
        let lastName = nameParts.count > 1 ? String(nameParts.dropFirst().joined(separator: " ")) : ""
        let shopifyId = try? await shopifyDataSource.syncUser(email: email, firstName: firstName, lastName: lastName)
        user.shopifyCustomerID = shopifyId
        return user
    }

    public func signInWithGoogle() async throws -> AuthUser {
        var user = try await googleDataSource.signIn()
        if let email = user.email {
            let shopifyId = try? await shopifyDataSource.syncUser(email: email, firstName: user.displayName, lastName: nil)
            user.shopifyCustomerID = shopifyId
        }
        return user
    }

    public func signOut() throws {
        try firebaseDataSource.signOut()
    }

    public func sendVerificationEmail() async throws {
        try await firebaseDataSource.sendVerificationEmail()
    }

    public var currentUser: AuthUser? {
        firebaseDataSource.currentUser
    }
}
