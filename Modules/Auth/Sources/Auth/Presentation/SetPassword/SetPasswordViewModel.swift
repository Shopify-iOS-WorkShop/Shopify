//
//  SetPasswordViewModel.swift
//  Auth
//
//  Created by Agent on 02/07/2026.
//

import Foundation
import Combine

/// Drives SetPasswordView — presented exclusively to social sign-in users
/// (Google / Apple) who need to create a Shopify-compatible password so the
/// Auth module can call customerCreate + customerAccessTokenCreate and
/// complete the account bridging flow.
public final class SetPasswordViewModel: ObservableObject {

    // MARK: - Read-only (pre-filled from social sign-in result)

    /// The email returned by the social provider — shown as static text, not editable.
    public let email: String

    // MARK: - Editable Inputs

    @Published public var firstName: String = ""
    @Published public var lastName: String = ""
    @Published public var password: String = ""
    @Published public var confirmPassword: String = ""

    // MARK: - Output State

    @Published public private(set) var isLoading: Bool = false
    @Published public private(set) var errorMessage: String? = nil
    @Published public private(set) var completedSession: Session? = nil

    // MARK: - Dependency

    private let setPasswordUseCase: SetPasswordForSocialUserUseCaseProtocol

    // MARK: - Init

    public init(
        email: String,
        displayName: String?,
        setPasswordUseCase: SetPasswordForSocialUserUseCaseProtocol
    ) {
        self.email = email
        self.setPasswordUseCase = setPasswordUseCase

        // Pre-split social displayName into firstName / lastName if available
        let parts = (displayName ?? "")
            .trimmingCharacters(in: .whitespaces)
            .components(separatedBy: " ")
            .filter { !$0.isEmpty }
        self.firstName = parts.first ?? ""
        self.lastName = parts.dropFirst().joined(separator: " ")
    }

    public convenience init(
        email: String,
        displayName: String?,
        repository: AuthRepositoryProtocol = AuthRepositoryFactory.make()
    ) {
        self.init(
            email: email,
            displayName: displayName,
            setPasswordUseCase: SetPasswordForSocialUserUseCase(repository: repository)
        )
    }

    // MARK: - Computed Validation

    public var isFormValid: Bool {
        !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
        password.count >= 8 &&
        password == confirmPassword
    }

    public var passwordLengthError: String? {
        guard !password.isEmpty else { return nil }
        return password.count >= 8 ? nil : "Password must be at least 8 characters"
    }

    public var passwordMatchError: String? {
        guard !confirmPassword.isEmpty else { return nil }
        return password == confirmPassword ? nil : "Passwords do not match"
    }

    // MARK: - Actions

    public func confirm() {
        guard isFormValid else {
            if firstName.trimmingCharacters(in: .whitespaces).isEmpty {
                errorMessage = "First name is required."
            } else if password.count < 8 {
                errorMessage = "Password must be at least 8 characters."
            } else {
                errorMessage = "Passwords do not match."
            }
            return
        }

        isLoading = true
        errorMessage = nil

        Task { @MainActor in
            let result = await setPasswordUseCase.execute(
                email: email,
                password: password,
                confirmPassword: confirmPassword,
                firstName: firstName.trimmingCharacters(in: .whitespacesAndNewlines),
                lastName: lastName.trimmingCharacters(in: .whitespacesAndNewlines)
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
}
