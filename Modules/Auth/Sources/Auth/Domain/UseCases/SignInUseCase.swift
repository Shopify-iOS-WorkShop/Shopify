//
//  File.swift
//  
//
//  Created by Ahmed Elkady on 27/06/2026.
//

import Foundation

public protocol SignInUseCaseProtocol {
    func execute(email: String, password: String) async -> Result<Session, AuthError>
}

public final class SignInUseCase: SignInUseCaseProtocol {
    private let repository: AuthRepositoryProtocol

    public init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(email: String, password: String) async -> Result<Session, AuthError> {
        if let emailError = AuthInputValidator.validateEmail(email) {
            return .failure(emailError)
        }

        guard !password.isEmpty else {
            return .failure(.validation("Password is required."))
        }

        return await repository.signIn(
            email: email.trimmingCharacters(in: .whitespacesAndNewlines),
            password: password
        )
    }
}
