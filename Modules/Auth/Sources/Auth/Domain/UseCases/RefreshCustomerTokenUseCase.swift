import Foundation

public protocol RefreshCustomerTokenUseCaseProtocol {
    func execute(email: String, password: String) async -> Result<Session, AuthError>
}

public final class RefreshCustomerTokenUseCase: RefreshCustomerTokenUseCaseProtocol {
    private let repository: AuthRepositoryProtocol

    public init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(email: String, password: String) async -> Result<Session, AuthError> {
        await repository.signIn(email: email, password: password)
    }
}
