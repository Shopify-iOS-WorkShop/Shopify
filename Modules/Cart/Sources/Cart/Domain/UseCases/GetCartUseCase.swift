import Foundation

public struct GetCartUseCase: Sendable {
    private let repository: CartRepository

    public init(repository: CartRepository) {
        self.repository = repository
    }

    public func execute(id: CartID) async throws -> Cart {
        return try await repository.getCart(id: id)
    }
}
