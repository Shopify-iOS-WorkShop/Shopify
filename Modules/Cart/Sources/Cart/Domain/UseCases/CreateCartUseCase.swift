import Foundation

public struct CreateCartUseCase: Sendable {
    private let repository: CartRepository

    public init(repository: CartRepository) {
        self.repository = repository
    }

    public func execute(customerID: String? = nil) async throws -> Cart {
        return try await repository.createCart(customerID: customerID)
    }
}
