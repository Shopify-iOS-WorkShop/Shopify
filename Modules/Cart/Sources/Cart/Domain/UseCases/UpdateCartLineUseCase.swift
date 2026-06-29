import Foundation

public struct UpdateCartLineUseCase: Sendable {
    private let repository: CartRepository
    private let removeUseCase: RemoveCartLineUseCase

    public init(repository: CartRepository) {
        self.repository = repository
        self.removeUseCase = RemoveCartLineUseCase(repository: repository)
    }

    public func execute(cartID: CartID, lineID: CartLineID, quantity: Int) async throws -> Cart {
        if quantity <= 0 {
            return try await removeUseCase.execute(cartID: cartID, lineID: lineID)
        }
        return try await repository.updateLineItemQuantity(cartID: cartID, lineID: lineID, quantity: quantity)
    }
}
