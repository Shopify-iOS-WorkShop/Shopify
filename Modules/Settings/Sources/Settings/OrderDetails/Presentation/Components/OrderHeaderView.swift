//
//  File.swift
//  
//
//  Created by Mazen Amr on 07/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct OrderHeaderView: View {
    let order: FullOrder
    
    public init(order: FullOrder) {
        self.order = order
    }
    
    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Order #\(order.orderNumber)")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(formattedDate(order.processedAt))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            
            Text(order.financialStatus.capitalized)
                .font(.caption)
                .fontWeight(.bold)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(order.financialStatus.lowercased() == "paid" ? Color.green.opacity(0.15) : Color.orange.opacity(0.15))
                .foregroundColor(order.financialStatus.lowercased() == "paid" ? .green : .orange)
                .clipShape(Capsule())
        }
        .padding(.horizontal)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f.string(from: date)
    }
}
