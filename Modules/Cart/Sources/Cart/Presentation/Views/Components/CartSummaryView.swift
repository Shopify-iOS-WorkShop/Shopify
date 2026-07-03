import SwiftUI
import Common

public struct CartSummaryView: View {
    let cost: CartCost
    let onCheckout: () -> Void
    
    public init(
        cost: CartCost,
        onCheckout: @escaping () -> Void
    ) {
        self.cost = cost
        self.onCheckout = onCheckout
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                HStack {
                    Text("Subtotal")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(cost.subtotalAmount.formatted)
                        .fontWeight(.medium)
                }
                
                // Assuming tax or extra checkout charges
                if cost.checkoutChargeAmount.amount > 0 {
                    HStack {
                        Text("Taxes & Charges")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(cost.checkoutChargeAmount.formatted)
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
                    Text(cost.totalAmount.formatted)
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
