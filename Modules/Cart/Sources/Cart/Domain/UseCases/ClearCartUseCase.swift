import Foundation

public struct ClearCartUseCase: Sendable {
    private let repository: CartRepository

    public init(repository: CartRepository) {
        self.repository = repository
    }

    public func execute(cartID: CartID) async throws -> Cart {
        return try await repository.clearCart(cartID: cartID)
    }
}
