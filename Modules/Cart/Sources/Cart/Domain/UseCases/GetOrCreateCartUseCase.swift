import Foundation
import Common

public protocol GetOrCreateCartUseCaseProtocol {
    func execute() async -> Result<Cart, AppError>
}

public struct GetOrCreateCartUseCase: GetOrCreateCartUseCaseProtocol {
    private let repository: CartRepositoryProtocol

    public init(repository: CartRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() async -> Result<Cart, AppError> {
        let result = await repository.fetchCart()
        switch result {
        case .success(let cart):
            return .success(cart)
        case .failure:
            // If fetch fails (not found or expired), create a new one
            return await repository.createCart()
        }
    }
}
