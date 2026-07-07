//
//  File.swift
//  
//
//  Created by Mazen Amr on 07/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct OrderItemsView: View {
    let items: [OrderLineItem]
    let formatPrice: (Double) -> String
    
    public init(items: [OrderLineItem], formatPrice: @escaping (Double) -> String) {
        self.items = items
        self.formatPrice = formatPrice
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Items")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(spacing: 0) {
                ForEach(items) { item in
                    HStack(spacing: 12) {
                        ZStack {
                            Color(UIColor.tertiarySystemFill)
                            if let url = item.imageURL {
                                AsyncImage(url: url) { image in
                                    image.resizable().scaledToFill()
                                } placeholder: {
                                    Image(systemName: "photo")
                                        .foregroundColor(.secondary)
                                }
                            } else {
                                Image(systemName: "photo")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .lineLimit(2)
                            
                            if let variant = item.variantTitle, !variant.isEmpty {
                                Text(variant)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Text("Qty: \(item.quantity)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text(formatPrice(item.price))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .padding()
                    
                    if item.id != items.last?.id {
                        Divider().padding(.leading, 84)
                    }
                }
            }
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}
