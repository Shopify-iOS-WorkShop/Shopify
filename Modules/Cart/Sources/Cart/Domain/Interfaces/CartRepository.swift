import Foundation

public protocol CartRepository: Sendable {
    func getCart(id: CartID) async throws -> Cart
    func createCart(customerID: String?) async throws -> Cart
    func addLineItem(cartID: CartID, variantID: ProductVariantID, quantity: Int) async throws -> Cart
    func updateLineItemQuantity(cartID: CartID, lineID: CartLineID, quantity: Int) async throws -> Cart
    func removeLineItem(cartID: CartID, lineID: CartLineID) async throws -> Cart
    func clearCart(cartID: CartID) async throws -> Cart
}
