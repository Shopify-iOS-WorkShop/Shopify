import Foundation

public protocol RecoverPasswordUseCaseProtocol {
    func execute(email: String) async -> Result<Void, AuthError>
}

public final class RecoverPasswordUseCase: RecoverPasswordUseCaseProtocol {
    private let repository: AuthRepositoryProtocol

    public init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(email: String) async -> Result<Void, AuthError> {
        if let emailError = AuthInputValidator.validateEmail(email) {
            return .failure(emailError)
        }

        return await repository.recoverPassword(email: email.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}
