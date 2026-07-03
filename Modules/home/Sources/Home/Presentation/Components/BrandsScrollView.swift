//
//  File.swift
//  
//
//  Created by Mazen Amr on 27/06/2026.
//

import Foundation
import SwiftUI
import Common

public struct BrandsScrollView: View {
    public let brands: [Brand]
    @Environment(HomeCoordinator.self) private var coordinator

    public init(brands: [Brand]) {
        self.brands = brands
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(brands) { brand in
                    Button(action: {
                        coordinator.push(.productListing(collectionId: brand.id, title: brand.title))
                    }) {
                        VStack(spacing: 6) {
                            Circle()
                                .strokeBorder(Color(hex: "#E0E0E0"), lineWidth: 1.5)
                                .frame(width: 62, height: 62)
                                .background(Circle().fill(DS.lightGray))
                                .overlay(
                                    Group {
                                        if let url = brand.imageURL {
                                            AsyncImage(url: url) { phase in
                                                switch phase {
                                                case .empty:
                                                    ProgressView()
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .padding(16)
                                                        .clipShape(Circle())
                                                case .failure:
                                                    Image(systemName: "bag")
                                                        .font(.system(size: 22, weight: .light))
                                                        .foregroundColor(DS.textPri)
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                            .frame(width: 60, height: 60)
                                            .clipShape(Circle())
                                        } else {
                                            Image(systemName: "bag")
                                                .font(.system(size: 22, weight: .light))
                                                .foregroundColor(DS.textPri)
                                        }
                                    }
                                )

                            Text(brand.title)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(DS.textPri)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}
