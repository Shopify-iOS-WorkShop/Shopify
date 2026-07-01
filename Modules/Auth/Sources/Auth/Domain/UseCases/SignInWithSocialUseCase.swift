//
//  File.swift
//  
//
//  Created by Ahmed Elkady on 27/06/2026.
//

import Foundation

public protocol SignInWithSocialUseCaseProtocol {
    func execute(provider: AuthProvider) async -> Result<SocialSignInResult, AuthError>
}

public final class SignInWithSocialUseCase: SignInWithSocialUseCaseProtocol {
    private let repository: AuthRepositoryProtocol

    public init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(provider: AuthProvider) async -> Result<SocialSignInResult, AuthError> {
        await repository.signInWithSocial(provider: provider)
    }
}
