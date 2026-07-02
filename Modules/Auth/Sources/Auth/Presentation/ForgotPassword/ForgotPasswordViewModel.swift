//
//  ForgotPasswordViewModel.swift
//  Auth
//
//  Created by Agent on 02/07/2026.
//

import Foundation
import Combine

public final class ForgotPasswordViewModel: ObservableObject {

    // MARK: - Input
    @Published public var email: String = ""

    // MARK: - Output State
    @Published public private(set) var isLoading: Bool = false
    @Published public private(set) var errorMessage: String? = nil
    @Published public private(set) var isEmailSent: Bool = false

    // MARK: - Dependency
    private let recoverPasswordUseCase: RecoverPasswordUseCaseProtocol

    // MARK: - Init
    public init(recoverPasswordUseCase: RecoverPasswordUseCaseProtocol) {
        self.recoverPasswordUseCase = recoverPasswordUseCase
    }

    public convenience init(repository: AuthRepositoryProtocol = AuthRepositoryFactory.make()) {
        self.init(recoverPasswordUseCase: RecoverPasswordUseCase(repository: repository))
    }

    // MARK: - Computed

    public var isFormValid: Bool {
        isValidEmail(email)
    }

    // MARK: - Actions

    public func sendResetEmail() {
        guard isFormValid else {
            errorMessage = "Please enter a valid email address."
            return
        }

        isLoading = true
        errorMessage = nil
        isEmailSent = false

        Task { @MainActor in
            let result = await recoverPasswordUseCase.execute(
                email: email.trimmingCharacters(in: .whitespacesAndNewlines)
            )

            isLoading = false
            switch result {
            case .success:
                isEmailSent = true
            case .failure(let error):
                errorMessage = error.userFacingMessage
            }
        }
    }

    // MARK: - Private

    private func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }
}
