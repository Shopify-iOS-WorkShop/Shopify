//
//  File.swift
//  
//
//  Created by Mazen Amr on 07/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct OrderSummaryView: View {
    let order: FullOrder
    let formatPrice: (Double) -> String
    
    public init(order: FullOrder, formatPrice: @escaping (Double) -> String) {
        self.order = order
        self.formatPrice = formatPrice
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Order Summary")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                OrderSummaryRow(title: "Payment Method", value: order.financialStatus.lowercased() == "paid" ? "Card" : "Cash on Delivery")
                OrderSummaryRow(title: "Subtotal", value: formatPrice(order.subtotalAmount))
                OrderSummaryRow(title: "Shipping", value: formatPrice(order.shippingFee))
                
                Divider()
                
                HStack {
                    Text("Total")
                        .font(.headline)
                    Spacer()
                    Text(formatPrice(order.totalAmount))
                        .font(.headline)
                        .foregroundColor(.red)
                }
            }
            .padding()
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}

private struct OrderSummaryRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .font(.subheadline)
    }
}
