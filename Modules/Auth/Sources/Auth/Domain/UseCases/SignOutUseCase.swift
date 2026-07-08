import Foundation

public protocol SignOutUseCaseProtocol {
    func execute() async -> Result<Void, AuthError>
}

public final class SignOutUseCase: SignOutUseCaseProtocol {
    private let repository: AuthRepositoryProtocol

    public init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() async -> Result<Void, AuthError> {
        await repository.signOut()
    }
}
