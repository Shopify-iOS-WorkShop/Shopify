import SwiftUI
import Common

public struct EmptyCartView: View {
    let onShopTapped: () -> Void
    
    public init(onShopTapped: @escaping () -> Void) {
        self.onShopTapped = onShopTapped
    }
    
    public var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "cart")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.secondary.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("Your Cart is Empty")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Looks like you haven't added anything to your cart yet.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            PrimaryButton(
                title: "Start Shopping",
                action: onShopTapped
            )
            .padding(.horizontal, 32)
            .padding(.top, 16)
            
            Spacer()
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}
