//
//  CartSummaryView.swift
//  Cart
//

import SwiftUI

struct CartSummaryView: View {
    let totals: CartTotals
    let discount: Money?

    var body: some View {
        VStack(spacing: 0) {
            summaryRow(label: "Subtotal", value: totals.subtotal.formatted)
            Divider().padding(.vertical, 10)

            summaryRow(label: "Shipping", value: "Free")
            Divider().padding(.vertical, 10)

            if let discount = discount, discount.amount != 0 {
                summaryRow(
                    label: "Discount",
                    value: "-\(discount.formatted)",
                    valueColor: Color(red: 0.85, green: 0.1, blue: 0.1)
                )
                Divider().padding(.vertical, 10)
            }

            // Total
            HStack {
                Text("Total")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                Spacer()
                Text(totals.total.formatted)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
    }

    @ViewBuilder
    private func summaryRow(label: String, value: String, valueColor: Color = .primary) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(valueColor)
        }
    }
}
