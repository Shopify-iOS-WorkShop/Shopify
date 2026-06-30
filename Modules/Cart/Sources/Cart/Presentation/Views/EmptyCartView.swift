//
//  EmptyCartView.swift
//  Cart
//

import SwiftUI

struct EmptyCartView: View {
    let onContinueShopping: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "cart")
                .font(.system(size: 72, weight: .thin))
                .foregroundColor(Color(.systemGray3))

            VStack(spacing: 8) {
                Text("Your cart is empty")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)

                Text("Add items to get started")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }

            Button(action: onContinueShopping) {
                Text("Continue Shopping")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: 220)
                    .frame(height: 50)
                    .background(Color(red: 0.85, green: 0.1, blue: 0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
