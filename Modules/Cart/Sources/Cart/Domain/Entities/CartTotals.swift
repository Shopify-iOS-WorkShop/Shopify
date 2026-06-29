import Foundation

public struct CartTotals: Equatable, Codable, Sendable {
    public let subtotal: Money
    public let total: Money
    public let totalTax: Money?

    public init(subtotal: Money, total: Money, totalTax: Money? = nil) {
        self.subtotal = subtotal
        self.total = total
        self.totalTax = totalTax
    }
}
