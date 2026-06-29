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

    public convenience init() {
        self.init(
            firebaseDataSource: FirebaseAuthDataSource(),
            googleDataSource: GoogleSignInDataSource()
        )
    }

    init(
        firebaseDataSource: FirebaseAuthDataSource = .init(),
        googleDataSource: GoogleSignInDataSource = .init()
    ) {
        self.firebaseDataSource = firebaseDataSource
        self.googleDataSource = googleDataSource
    }

    public func login(email: String, password: String) async throws -> AuthUser {
        try await firebaseDataSource.login(email: email, password: password)
    }

    public func register(email: String, password: String, name: String) async throws -> AuthUser {
        try await firebaseDataSource.register(email: email, password: password, name: name)
    }

    public func signInWithGoogle() async throws -> AuthUser {
        try await googleDataSource.signIn()
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
