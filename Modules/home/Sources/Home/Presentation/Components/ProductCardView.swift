//
//  ProductCardView.swift
//
//
//  Created by Mazen Amr on 27/06/2026.
//

import Foundation
import SwiftUI
import Common

public struct ProductCardView: View {
    public let product: Product
    @Environment(CurrencyStore.self) private var currencyStore
    @State private var isWishlisted = false
    
    public init(product: Product) {
        self.product = product
    }

    /// Formatted price string respecting the selected currency.
    private var priceText: String {
        currencyStore.convert(product.price)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "#F0F0F0"))
                    
                    if let url = product.imageURL {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .failure:
                                Image(systemName: "bag")
                                    .font(.system(size: 36, weight: .ultraLight))
                                    .foregroundColor(Color(hex: "#CCCCCC"))
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Image(systemName: "bag")
                            .font(.system(size: 36, weight: .ultraLight))
                            .foregroundColor(Color(hex: "#CCCCCC"))
                    }
                }
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Button(action: { isWishlisted.toggle() }) {
                    Image(systemName: isWishlisted ? "heart.fill" : "heart")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(isWishlisted ? DS.red : DS.textSec)
                        .frame(width: 28, height: 28)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                }
                .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(product.vendor)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(DS.red)
                    .tracking(0.8)
                    .padding(.top, 8)
                
                Text(product.title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(DS.textPri)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                HStack(spacing: 4) {
                    Text(priceText)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(DS.textPri)
                    
                    Spacer()
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                        .foregroundColor(DS.red)
                    
                    Text(String(format: "%.1f", product.rating))
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(DS.red)
                }
                .padding(.top, 2)
                .padding(.bottom, 10)
            }
            .padding(.horizontal, 10)
        }
        .background(DS.cardBG)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 3)
    }
}
