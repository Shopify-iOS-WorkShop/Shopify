import Foundation

public struct AddCartLineUseCase: Sendable {
    private let repository: CartRepository

    public init(repository: CartRepository) {
        self.repository = repository
    }

    public func execute(cartID: CartID, variantID: ProductVariantID, quantity: Int) async throws -> Cart {
        guard quantity > 0 else {
            throw CartError.invalidQuantity
        }
        return try await repository.addLineItem(cartID: cartID, variantID: variantID, quantity: quantity)
    }
}
