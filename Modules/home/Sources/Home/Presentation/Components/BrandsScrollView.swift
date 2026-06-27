//
//  File.swift
//  
//
//  Created by Mazen Amr on 27/06/2026.
//

import Foundation
public struct BrandsScrollView: View {
    public let brands: [Brand]

    public init(brands: [Brand]) {
        self.brands = brands
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(brands) { brand in
                    VStack(spacing: 6) {
                        Circle()
                            .strokeBorder(Color(hex: "#E0E0E0"), lineWidth: 1.5)
                            .frame(width: 62, height: 62)
                            .background(Circle().fill(Color.white))
                            .overlay(
                                Image(systemName: brand.iconName)
                                    .font(.system(size: 22, weight: .light))
                                    .foregroundColor(DS.textPri)
                            )

                        Text(brand.title)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(DS.textPri)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

