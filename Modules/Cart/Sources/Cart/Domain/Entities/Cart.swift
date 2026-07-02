import Foundation

public struct Cart: Equatable {
    public let id: String
    public let checkoutUrl: URL
    public let totalQuantity: Int
    public let note: String?
    public let lines: [CartLine]
    public let cost: CartCost
    public let discountCodes: [CartDiscount]

    public init(
        id: String,
        checkoutUrl: URL,
        totalQuantity: Int,
        note: String?,
        lines: [CartLine],
        cost: CartCost,
        discountCodes: [CartDiscount]
    ) {
        self.id = id
        self.checkoutUrl = checkoutUrl
        self.totalQuantity = totalQuantity
        self.note = note
        self.lines = lines
        self.cost = cost
        self.discountCodes = discountCodes
    }
}
