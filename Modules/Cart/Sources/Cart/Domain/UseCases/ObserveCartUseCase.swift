import Foundation

public protocol ObserveCartUseCaseProtocol {
    func execute() -> AsyncStream<Cart?>
}

public struct ObserveCartUseCase: ObserveCartUseCaseProtocol {
    private let repository: CartRepositoryProtocol

    public init(repository: CartRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() -> AsyncStream<Cart?> {
        return repository.observeCart()
    }
}
