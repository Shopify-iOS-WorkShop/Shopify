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
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            return result.user.toDomain()
        } catch {
            throw mapFirebaseError(error)
        }
    }

    func signUp(email: String, password: String, firstName: String, lastName: String) async throws -> AuthUser {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespacesAndNewlines)
            try await changeRequest.commitChanges()
            return result.user.toDomain()
        } catch {
            throw mapFirebaseError(error)
        }
    }

    func sendVerificationEmail() async throws {
        do {
            try await Auth.auth().currentUser?.sendEmailVerification()
        } catch {
            throw mapFirebaseError(error)
        }
    }
    
    func sendPasswordReset(email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            throw mapFirebaseError(error)
        }
    }

    func signOut() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw mapFirebaseError(error)
        }
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

private func mapFirebaseError(_ error: Error) -> AuthError {
    let nsError = error as NSError
    if nsError.domain == AuthErrorDomain {
        if let code = AuthErrorCode.Code(rawValue: nsError.code) {
            switch code {
            case .emailAlreadyInUse:
                return .authentication("This email is already in use by another account.")
            case .wrongPassword, .userNotFound, .invalidCredential:
                return .authentication("Invalid email or password.")
            case .invalidEmail:
                return .authentication("The email address is badly formatted.")
            case .weakPassword:
                return .authentication("The password must be 6 characters long or more.")
            case .networkError:
                return .authentication("A network error occurred. Please check your connection.")
            case .userDisabled:
                return .authentication("This account has been disabled. Please contact support.")
            case .tooManyRequests:
                return .authentication("Too many attempts. Please try again later.")
            default:
                return .authentication(error.localizedDescription)
            }
        }
    }
    return .authentication(error.localizedDescription)
}
