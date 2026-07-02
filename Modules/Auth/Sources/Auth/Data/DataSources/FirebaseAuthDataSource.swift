//
//  File.swift
//  
//
//  Created by Ahmed Elkady on 27/06/2026.
//

import Foundation
import FirebaseAuth

final class FirebaseAuthDataSource {

    func signIn(email: String, password: String) async throws -> AuthUser {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user.toDomain()
    }

    func signUp(email: String, password: String, firstName: String, lastName: String) async throws -> AuthUser {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        let changeRequest = result.user.createProfileChangeRequest()
        changeRequest.displayName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespacesAndNewlines)
        try await changeRequest.commitChanges()
        return result.user.toDomain()
    }

    func sendVerificationEmail() async throws {
        try await Auth.auth().currentUser?.sendEmailVerification()
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    var currentUser: AuthUser? {
        Auth.auth().currentUser?.toDomain()
    }
}

private extension FirebaseAuth.User {
    func toDomain() -> AuthUser {
        AuthUser(
            uid: uid,
            email: email,
            displayName: displayName,
            photoURL: photoURL,
            isEmailVerified: isEmailVerified,
            phoneNumber: phoneNumber,
            providerID: providerData.first?.providerID ?? "password",
            creationDate: metadata.creationDate,
            lastSignInDate: metadata.lastSignInDate
        )
    }
}
