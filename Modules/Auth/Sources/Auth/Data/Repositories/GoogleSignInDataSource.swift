//
//  File.swift
//  
//
//  Created by Ahmed Elkady on 27/06/2026.
//

import Foundation
final class AuthRepository: AuthRepositoryInterface {

    private let firebaseDataSource: FirebaseAuthDataSource
    private let googleDataSource: GoogleSignInDataSource

    init(
        firebaseDataSource: FirebaseAuthDataSource = .init(),
        googleDataSource: GoogleSignInDataSource = .init()
    ) {
        self.firebaseDataSource = firebaseDataSource
        self.googleDataSource = googleDataSource
    }

    func login(email: String, password: String) async throws -> AuthUser {
        try await firebaseDataSource.login(email: email, password: password)
    }

    func register(email: String, password: String, name: String) async throws -> AuthUser {
        try await firebaseDataSource.register(email: email, password: password, name: name)
    }

    func signInWithGoogle() async throws -> AuthUser {
        try await googleDataSource.signIn()
    }

    func signOut() throws {
        try firebaseDataSource.signOut()
    }

    func sendVerificationEmail() async throws {
        try await firebaseDataSource.sendVerificationEmail()
    }

    var currentUser: AuthUser? {
        firebaseDataSource.currentUser
    }
}
