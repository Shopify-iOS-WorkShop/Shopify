//
//  File.swift
//  
//
//  Created by Mazen Amr on 29/06/2026.
//

import Foundation
import SwiftUI
import Observation
import Common

public struct ProductCardView: View {
    public let product: Product
    @Environment(CurrencyStore.self) private var currencyStore
    @State private var isWishlisted = false
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(DS.fieldBG)
                    
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
                                    .foregroundColor(DS.textSec.opacity(0.55))
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Image(systemName: "bag")
                            .font(.system(size: 36, weight: .ultraLight))
                            .foregroundColor(DS.textSec.opacity(0.55))
                    }
                }
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Button(action: { isWishlisted.toggle() }) {
                    Image(systemName: isWishlisted ? "heart.fill" : "heart")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(isWishlisted ? DS.red : DS.textSec)
                        .frame(width: 28, height: 28)
                        .background(DS.cardBG)
                        .clipShape(Circle())
                        .shadow(color: DS.shadow.opacity(0.12), radius: 4, x: 0, y: 2)
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
                    Text(currencyStore.convert(product.price))
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
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(DS.lightGray.opacity(0.8), lineWidth: 1)
        }
        .shadow(color: DS.shadow.opacity(0.08), radius: 10, x: 0, y: 5)
    }
}
