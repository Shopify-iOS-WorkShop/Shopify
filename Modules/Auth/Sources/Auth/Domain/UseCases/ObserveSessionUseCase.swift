import Foundation

public protocol ObserveSessionUseCaseProtocol {
    func execute() -> Session?
}

public final class ObserveSessionUseCase: ObserveSessionUseCaseProtocol {
    private let repository: AuthRepositoryProtocol

    public init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() -> Session? {
        repository.currentSession()
    }
}
