//
//  File.swift
//  
//
//  Created by Ahmed Elkady on 27/06/2026.
//

import Foundation

public protocol SignUpUseCaseProtocol {
    func execute(email: String, password: String, confirmPassword: String, firstName: String, lastName: String) async -> Result<Session, AuthError>
}

public final class SignUpUseCase: SignUpUseCaseProtocol {
    private let repository: AuthRepositoryProtocol

    public init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(email: String, password: String, confirmPassword: String, firstName: String, lastName: String) async -> Result<Session, AuthError> {
        if let nameError = AuthInputValidator.validateName(firstName: firstName, lastName: lastName) {
            return .failure(nameError)
        }

        if let emailError = AuthInputValidator.validateEmail(email) {
            return .failure(emailError)
        }

        if let passwordError = AuthInputValidator.validateConfirmedPassword(password, confirmPassword) {
            return .failure(passwordError)
        }

        return await repository.signUp(
            email: email.trimmingCharacters(in: .whitespacesAndNewlines),
            password: password,
            firstName: firstName.trimmingCharacters(in: .whitespacesAndNewlines),
            lastName: lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }
}
