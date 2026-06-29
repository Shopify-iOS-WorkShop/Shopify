//
//  File.swift
//  
//
//  Created by Ahmed Elkady on 27/06/2026.
//

import Foundation
import UIKit
import GoogleSignIn
import FirebaseAuth

final class GoogleSignInDataSource {

    @MainActor
    func signIn() async throws -> AuthUser {
        try configureGoogleSignInIfNeeded()

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

    private func configureGoogleSignInIfNeeded() throws {
        if GIDSignIn.sharedInstance.configuration != nil {
            return
        }

        guard
            let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
            let config = NSDictionary(contentsOfFile: path),
            let clientID = config["CLIENT_ID"] as? String,
            !clientID.isEmpty
        else {
            throw AuthDataError.missingGoogleClientID
        }

        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
    }
}

enum AuthDataError: LocalizedError {
    case missingRootViewController
    case missingGoogleToken
    case missingGoogleClientID

    var errorDescription: String? {
        switch self {
        case .missingRootViewController:
            return "Unable to present Google sign-in screen."
        case .missingGoogleToken:
            return "Google sign-in token is missing."
        case .missingGoogleClientID:
            return "Google Sign-In client ID is missing from GoogleService-Info.plist."
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
