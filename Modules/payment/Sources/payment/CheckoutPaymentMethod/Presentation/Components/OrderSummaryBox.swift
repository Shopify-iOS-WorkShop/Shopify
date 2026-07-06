//
//  File.swift
//  
//
//  Created by Mazen Amr on 04/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct OrderSummaryBox: View {
    let itemsCount: Int
    let subtotal: String
    let shippingFee: String
    let totalAmount: String
    
    public init(itemsCount: Int, subtotal: String, shippingFee: String, totalAmount: String) {
        self.itemsCount = itemsCount
        self.subtotal = subtotal
        self.shippingFee = shippingFee
        self.totalAmount = totalAmount
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Subtotal (\(itemsCount) items)").foregroundColor(.secondary)
                Spacer()
                Text(subtotal).fontWeight(.medium)
            }
            
            HStack {
                Text("Shipping Fee").foregroundColor(.secondary)
                Spacer()
                Text(shippingFee).fontWeight(.medium)
            }
            
            Divider().padding(.vertical, 4)
            
            HStack {
                Text("Total Amount").fontWeight(.semibold)
                Spacer()
                Text(totalAmount)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(DS.red)
            }
        }
        .font(.system(size: 14))
        .padding(16)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
