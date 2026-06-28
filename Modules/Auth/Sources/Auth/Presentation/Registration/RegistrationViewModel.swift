//
//  RegistrationViewModel.swift
//  Auth
//
//  Created by Ahmed Elkady on 28/06/2026.
//

import Foundation
import Combine

@available(iOS 13.0.0, *)
public final class RegistrationViewModel: ObservableObject {

    // MARK: - Input Fields
    @Published public var firstName: String       = ""
    @Published public var lastName: String        = ""
    @Published public var email: String           = ""
    @Published public var password: String        = ""
    @Published public var confirmPassword: String = ""

    // MARK: - State
    @Published public var isLoading: Bool              = false
    @Published public var errorMessage: String?        = nil
    @Published public var registrationSucceeded: Bool  = false

    // MARK: - Dependencies
    private let registerUseCase: RegisterUseCase
    private let googleSignInUseCase: GoogleSignInUseCase

    // MARK: - Init
    public init(
        registerUseCase: RegisterUseCase,
        googleSignInUseCase: GoogleSignInUseCase
    ) {
        self.registerUseCase = registerUseCase
        self.googleSignInUseCase = googleSignInUseCase
    }

    // MARK: - Computed Validation
    public var isFormValid: Bool {
        !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespaces).isEmpty  &&
        isValidEmail(email)                                      &&
        password.count >= 6                                      &&
        password == confirmPassword
    }

    public var passwordMatchError: String? {
        guard !confirmPassword.isEmpty else { return nil }
        return password == confirmPassword ? nil : "Passwords do not match"
    }

    public var passwordLengthError: String? {
        guard !password.isEmpty else { return nil }
        return password.count >= 6 ? nil : "Password must be at least 6 characters"
    }

    // MARK: - Register Action
    public func register() {
        guard validate() else { return }

        isLoading    = true
        errorMessage = nil

        Task { @MainActor in
            do {
                let fullName = "\(firstName.trimmingCharacters(in: .whitespaces)) \(lastName.trimmingCharacters(in: .whitespaces))"
                _ = try await registerUseCase.execute(
                    email: email.trimmingCharacters(in: .whitespaces),
                    password: password,
                    name: fullName
                )

                isLoading = false
                registrationSucceeded = true
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }
    
    // MARK: - Google Sign In Action
    public func signInWithGoogle() {
        isLoading = true
        errorMessage = nil
        
        Task { @MainActor in
            do {
                _ = try await googleSignInUseCase.execute()
                isLoading = false
                registrationSucceeded = true
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Helpers
    private func validate() -> Bool {
        if firstName.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "First name is required."
            return false
        }
        if lastName.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "Last name is required."
            return false
        }
        if !isValidEmail(email) {
            errorMessage = "Please enter a valid email address."
            return false
        }
        if password.count < 6 {
            errorMessage = "Password must be at least 6 characters."
            return false
        }
        if password != confirmPassword {
            errorMessage = "Passwords do not match."
            return false
        }
        return true
    }

    private func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }
}
