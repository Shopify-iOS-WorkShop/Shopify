//
//  File.swift
//  
//
//  Created by Ahmed Elkady on 27/06/2026.
//

import Foundation
public final class RegisterUseCase {
    private let repository: AuthRepositoryInterface

    public init(repository: AuthRepositoryInterface) {
        self.repository = repository
    }

    public func execute(email: String, password: String, name: String) async throws -> AuthUser {
        let user = try await repository.register(
            email: email,
            password: password,
            name: name
        )
        try await repository.sendVerificationEmail()
        return user
    }
}
