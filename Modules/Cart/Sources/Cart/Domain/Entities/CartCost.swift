import Foundation
import Common

public struct CartCost: Equatable {
    public let subtotalAmount: Money
    public let totalAmount: Money
    public let checkoutChargeAmount: Money

    public init(
        subtotalAmount: Money,
        totalAmount: Money,
        checkoutChargeAmount: Money
    ) {
        self.subtotalAmount = subtotalAmount
        self.totalAmount = totalAmount
        self.checkoutChargeAmount = checkoutChargeAmount
    }
}
