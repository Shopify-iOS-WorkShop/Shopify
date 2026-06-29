import Foundation

public struct CartLineItem: Equatable, Codable, Sendable {
    public let id: CartLineID
    public let variantID: ProductVariantID
    public let product: CartProduct
    public let variantTitle: String?
    public let quantity: Int
    public let availableQuantity: Int?
    public let unitPrice: Money
    public let totalPrice: Money

    public init(
        id: CartLineID,
        variantID: ProductVariantID,
        product: CartProduct,
        variantTitle: String? = nil,
        quantity: Int,
        availableQuantity: Int? = nil,
        unitPrice: Money,
        totalPrice: Money
    ) {
        self.id = id
        self.variantID = variantID
        self.product = product
        self.variantTitle = variantTitle
        self.quantity = quantity
        self.availableQuantity = availableQuantity
        self.unitPrice = unitPrice
        self.totalPrice = totalPrice
    }
}
