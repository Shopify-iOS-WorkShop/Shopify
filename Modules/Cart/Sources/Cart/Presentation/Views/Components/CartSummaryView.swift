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
                        .foregroundColor(DS.textSec)
                    Spacer()
                    // If we have a discount, the subtotal here should be the original price
                    Text(currencyStore.convert(originalSubtotal ?? cost.subtotalAmount.amount))
                        .fontWeight(.medium)
                }
                
                if let discount = discountAmount, discount > 0 {
                    HStack {
                        Text("Discount")
                            .foregroundColor(DS.red)
                        Spacer()
                        Text("-" + currencyStore.convert(discount))
                            .foregroundColor(DS.red)
                            .fontWeight(.medium)
                    }
                } else if !activeDiscountCodes.isEmpty {
                    HStack {
                        Text("Discount")
                            .foregroundColor(DS.red)
                        Spacer()
                        Text("Free Shipping")
                            .foregroundColor(DS.red)
                            .fontWeight(.medium)
                    }
                }
                
                Divider()
                    .padding(.vertical, 4)
                
                HStack {
                    Text("Total")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(DS.textPri)
                    Spacer()
                    Text(currencyStore.convert(cost.totalAmount.amount))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(DS.textPri)
                }
                
                Text("Taxes and shipping calculated at checkout")
                    .font(.caption)
                    .foregroundColor(DS.textSec)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            PrimaryButton(
                title: "Proceed to Checkout",
                action: onCheckout
            )
        }
        .padding()
        .background(DS.cardBG)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(DS.lightGray, lineWidth: 1)
        }
    }
}
