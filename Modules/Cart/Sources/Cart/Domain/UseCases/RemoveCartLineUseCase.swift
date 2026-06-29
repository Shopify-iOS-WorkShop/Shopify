import Foundation

public struct RemoveCartLineUseCase: Sendable {
    private let repository: CartRepository

    public init(repository: CartRepository) {
        self.repository = repository
    }

    public func execute(cartID: CartID, lineID: CartLineID) async throws -> Cart {
        return try await repository.removeLineItem(cartID: cartID, lineID: lineID)
    }
}
