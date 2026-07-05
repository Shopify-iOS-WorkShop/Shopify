import Foundation

public protocol ClearCartUseCaseProtocol {
    func execute() async
}

public struct ClearCartUseCase: ClearCartUseCaseProtocol {
    private let repository: CartRepositoryProtocol

    public init(repository: CartRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() async {
        await repository.clearCart()
    }
}
