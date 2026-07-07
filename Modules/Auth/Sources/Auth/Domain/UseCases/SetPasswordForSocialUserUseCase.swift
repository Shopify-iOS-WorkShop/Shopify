import Foundation

public protocol SetPasswordForSocialUserUseCaseProtocol {
    func execute(email: String, password: String, confirmPassword: String, firstName: String, lastName: String) async -> Result<Session, AuthError>
}

public final class SetPasswordForSocialUserUseCase: SetPasswordForSocialUserUseCaseProtocol {
    private let repository: AuthRepositoryProtocol

    public init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(email: String, password: String, confirmPassword: String, firstName: String, lastName: String) async -> Result<Session, AuthError> {
        // NOTE: This use case is deprecated with REST API approach
        // Social users (Google/Apple) now complete registration immediately without setting passwords
        // This is kept for backward compatibility but should not be called
        return .failure(.authentication("Password setup is no longer required for social sign-in users with REST API"))
    }
}
