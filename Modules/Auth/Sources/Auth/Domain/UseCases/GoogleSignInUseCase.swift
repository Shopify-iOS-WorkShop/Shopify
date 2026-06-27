//
//  File.swift
//  
//
//  Created by Ahmed Elkady on 27/06/2026.
//

import Foundation

@available(iOS 13.0.0, *)
public final class GoogleSignInUseCase {
    private let repository: AuthRepositoryInterface

    public init(repository: AuthRepositoryInterface) {
        self.repository = repository
    }

    public func execute() async throws -> AuthUser {
        try await repository.signInWithGoogle()
    }
}
