import SwiftUI
import Common

public struct CartSummaryView: View {
    let cost: CartCost
    let originalSubtotal: Decimal?
    let discountAmount: Decimal?
    let activeDiscountCodes: [CartDiscount]
    let onCheckout: () -> Void
    @Environment(CurrencyStore.self) private var currencyStore
    
    public init(
        cost: CartCost,
        originalSubtotal: Decimal? = nil,
        discountAmount: Decimal? = nil,
        activeDiscountCodes: [CartDiscount] = [],
        onCheckout: @escaping () -> Void
    ) {
        self.cost = cost
        self.originalSubtotal = originalSubtotal
        self.discountAmount = discountAmount
        self.activeDiscountCodes = activeDiscountCodes
        self.onCheckout = onCheckout
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                HStack {
                    Text("Subtotal")
                        .foregroundColor(.secondary)
                    Spacer()
                    // If we have a discount, the subtotal here should be the original price
                    Text(currencyStore.convert(originalSubtotal ?? cost.subtotalAmount.amount))
                        .fontWeight(.medium)
                }
                
                if let discount = discountAmount, discount > 0 {
                    HStack {
                        Text("Discount")
                            .foregroundColor(.pink)
                        Spacer()
                        Text("-" + currencyStore.convert(discount))
                            .foregroundColor(.pink)
                            .fontWeight(.medium)
                    }
                } else if !activeDiscountCodes.isEmpty {
                    HStack {
                        Text("Discount")
                            .foregroundColor(.pink)
                        Spacer()
                        Text("Free Shipping")
                            .foregroundColor(.pink)
                            .fontWeight(.medium)
                    }
                }
                
                Divider()
                    .padding(.vertical, 4)
                
                HStack {
                    Text("Total")
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                    Text(currencyStore.convert(cost.totalAmount.amount))
                        .font(.title3)
                        .fontWeight(.bold)
                }
                
                Text("Taxes and shipping calculated at checkout")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            PrimaryButton(
                title: "Proceed to Checkout",
                action: onCheckout
            )
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}
