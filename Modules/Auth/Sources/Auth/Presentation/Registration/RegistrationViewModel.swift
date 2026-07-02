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
    @Published public var fullName: String        = ""
    @Published public var firstName: String       = ""
    @Published public var lastName: String        = ""
    @Published public var email: String           = ""
    @Published public var password: String        = ""
    @Published public var confirmPassword: String = ""

    // MARK: - State
    @Published public var isLoading: Bool              = false
    @Published public var errorMessage: String?        = nil
    @Published public var guestModeActivated: Bool     = false
    @Published public private(set) var completedSession: Session? = nil
    @Published public private(set) var pendingSocialUser: SocialSignInResult? = nil
    @Published public private(set) var activeSession: UserSession? = nil

    // MARK: - Dependencies
    private let signUpUseCase: SignUpUseCaseProtocol
    private let signInWithSocialUseCase: SignInWithSocialUseCaseProtocol
    private let continueAsGuestUseCase: ContinueAsGuestUseCaseProtocol

    // MARK: - Init
    public init(
        signUpUseCase: SignUpUseCaseProtocol,
        signInWithSocialUseCase: SignInWithSocialUseCaseProtocol,
        continueAsGuestUseCase: ContinueAsGuestUseCaseProtocol
    ) {
        self.signUpUseCase = signUpUseCase
        self.signInWithSocialUseCase = signInWithSocialUseCase
        self.continueAsGuestUseCase = continueAsGuestUseCase
    }

    // MARK: - Computed Validation
    public var isFormValid: Bool {
        isNameValid &&
        isValidEmail(email) &&
        password.count >= 8 &&
        password == confirmPassword
    }

    public var passwordMatchError: String? {
        guard !confirmPassword.isEmpty else { return nil }
        return password == confirmPassword ? nil : "Passwords do not match"
    }

    public var passwordLengthError: String? {
        guard !password.isEmpty else { return nil }
        return password.count >= 8 ? nil : "Password must be at least 8 characters"
    }

    public var emailValidationError: String? {
        guard !email.isEmpty else { return nil }
        return isValidEmail(email) ? nil : "Please enter a valid email address"
    }

    // MARK: - Register Action
    public func register() {
        guard validate() else { return }

        isLoading    = true
        errorMessage = nil

        Task { @MainActor in
            let nameParts = resolvedNameParts
            let result = await signUpUseCase.execute(
                email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                password: password,
                confirmPassword: confirmPassword,
                firstName: nameParts.firstName,
                lastName: nameParts.lastName
            )

            isLoading = false
            switch result {
            case .success(let session):
                completedSession = session
            case .failure(let error):
                errorMessage = error.userFacingMessage
            }
        }
    }
    
    // MARK: - Google Sign In Action
    public func signInWithGoogle() {
        isLoading = true
        errorMessage = nil
        pendingSocialUser = nil
        
        Task { @MainActor in
            let result = await signInWithSocialUseCase.execute(provider: .google)

            isLoading = false
            switch result {
            case .success(let socialResult):
                pendingSocialUser = socialResult
                switch socialResult {
                case .existingUser(let session):
                    completedSession = session
                case .newUser:
                    errorMessage = "Set a password to finish connecting your Shopify account."
                }
            case .failure(let error):
                errorMessage = error.userFacingMessage
            }
        }
    }

    public convenience init(
        registerUseCase: SignUpUseCase,
        googleSignInUseCase: SignInWithSocialUseCase,
        continueAsGuestUseCase: ContinueAsGuestUseCase
    ) {
        self.init(
            signUpUseCase: registerUseCase,
            signInWithSocialUseCase: googleSignInUseCase,
            continueAsGuestUseCase: continueAsGuestUseCase
        )
    }

    public convenience init(repository: AuthRepositoryProtocol = AuthRepositoryFactory.make()) {
        self.init(
            signUpUseCase: SignUpUseCase(repository: repository),
            signInWithSocialUseCase: SignInWithSocialUseCase(repository: repository),
            continueAsGuestUseCase: ContinueAsGuestUseCase()
        )
    }

    // MARK: - Guest Mode Action
    @discardableResult
    public func continueAsGuest() -> UserSession {
        let session = continueAsGuestUseCase.execute()
        activeSession = session
        guestModeActivated = true
        return session
    }

    // MARK: - Helpers
    private func validate() -> Bool {
        if !isNameValid {
            errorMessage = "Full name is required."
            return false
        }
        if !isValidEmail(email) {
            errorMessage = "Please enter a valid email address."
            return false
        }
        if password.count < 8 {
            errorMessage = "Password must be at least 8 characters."
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

    private var isNameValid: Bool {
        !fullName.trimmingCharacters(in: .whitespaces).isEmpty ||
        (
            !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
            !lastName.trimmingCharacters(in: .whitespaces).isEmpty
        )
    }

    private var registrationName: String {
        let trimmedFullName = fullName.trimmingCharacters(in: .whitespaces)
        if !trimmedFullName.isEmpty {
            return trimmedFullName
        }

        return "\(firstName.trimmingCharacters(in: .whitespaces)) \(lastName.trimmingCharacters(in: .whitespaces))"
    }

    private var resolvedNameParts: (firstName: String, lastName: String) {
        let trimmedFirstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedFirstName.isEmpty || !trimmedLastName.isEmpty {
            return (trimmedFirstName, trimmedLastName)
        }

        let parts = registrationName
            .split(separator: " ", omittingEmptySubsequences: true)
            .map(String.init)
        return (
            parts.first ?? "",
            parts.dropFirst().joined(separator: " ")
        )
    }
}
