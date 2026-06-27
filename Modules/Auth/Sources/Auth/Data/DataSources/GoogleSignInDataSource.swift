//
//  File.swift
//  
//
//  Created by Ahmed Elkady on 27/06/2026.
//

import Foundation
import GoogleSignIn
import FirebaseAuth

final class GoogleSignInDataSource {

    @MainActor
    func signIn() async throws -> AuthUser {
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let rootViewController = windowScene.windows.first?.rootViewController
        else {
            throw AuthDataError.missingRootViewController
        }

        let result = try await GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController
        )

        guard let idToken = result.user.idToken?.tokenString else {
            throw AuthDataError.missingGoogleToken
        }

        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: result.user.accessToken.tokenString
        )

        let firebaseResult = try await Auth.auth().signIn(with: credential)
        return firebaseResult.user.toDomain()
    }
}

enum AuthDataError: LocalizedError {
    case missingRootViewController
    case missingGoogleToken

    var errorDescription: String? {
        switch self {
        case .missingRootViewController:
            return "Unable to present Google sign-in screen."
        case .missingGoogleToken:
            return "Google sign-in token is missing."
        }
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
            providerID: providerData.first?.providerID ?? "google.com",
            creationDate: metadata.creationDate,
            lastSignInDate: metadata.lastSignInDate
        )
    }
}
