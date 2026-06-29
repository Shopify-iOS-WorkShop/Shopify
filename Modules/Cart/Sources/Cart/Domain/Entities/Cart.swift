import Foundation

public struct Cart: Equatable, Codable, Sendable {
    public let id: CartID
    public let customerID: String?
    public let checkoutURL: URL?
    public let lines: [CartLineItem]
    public let totals: CartTotals

    public var totalQuantity: Int {
        lines.reduce(0) { $0 + $1.quantity }
    }

    public var isEmpty: Bool {
        lines.isEmpty
    }

    public init(
        id: CartID,
        customerID: String? = nil,
        checkoutURL: URL? = nil,
        lines: [CartLineItem],
        totals: CartTotals
    ) {
        self.id = id
        self.customerID = customerID
        self.checkoutURL = checkoutURL
        self.lines = lines
        self.totals = totals
    }
}
