//
//  File.swift
//  
//
//  Created by Mazen Amr on 29/06/2026.
//
import Foundation
import SwiftUI

public struct ProductListingView: View {
    public let title: String
    
    @State private var selectedFilter: String = "All"
    
    private let filters = ["All", "Price ↑", "Price ↓", "Accessories", "Shoes", "T-Shirts"]
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    private let dummyProducts: [Product] = [
        Product(id: "1", title: "Silk Drape Blouse", vendor: "AURELIA STUDIO", price: 124.00, rating: 4.5, imageURL: nil),
        Product(id: "2", title: "Linen Box Top", vendor: "MODERN OAK", price: 89.50, rating: 4.8, imageURL: nil),
        Product(id: "3", title: "Pleated Cotton Shirt", vendor: "ECO VERVE", price: 110.00, rating: 4.2, imageURL: nil),
        Product(id: "4", title: "Lace Trim Silk Cami", vendor: "LUNA COLLECTIVE", price: 75.00, rating: 4.9, imageURL: nil)
    ]
    
    public init(title: String) {
        self.title = title
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(filters, id: \.self) { filter in
                        Button(action: {
                            selectedFilter = filter
                        }) {
                            Text(filter)
                                .font(.system(size: 13, weight: .medium))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedFilter == filter ? DS.navy : DS.background)
                                .foregroundColor(selectedFilter == filter ? .white : DS.textPri)
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            
            HStack {
                Text("Sort by:")
                    .font(.system(size: 13))
                    .foregroundColor(DS.textSec)
                
                Button(action: {
                }) {
                    HStack(spacing: 4) {
                        Text("Price")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(DS.textPri)
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(DS.textPri)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(dummyProducts) { product in
                        ProductCardView(product: product)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
            
                }) {
                    Image(systemName: "line.3.horizontal.decrease")
                        .foregroundColor(DS.textPri)
                }
            }
        }
    }
}
