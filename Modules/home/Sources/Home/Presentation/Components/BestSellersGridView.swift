//
//  BestSellersGridView.swift
//
//
//  Created by Mazen Amr on 27/06/2026.
//

import Foundation
import SwiftUI

public struct BestSellersGridView: View {
    public let products: [Product]
    public let favoritedIDs: Set<String>
    public let onFavoriteTap: ((Product) -> Void)?
    
    @Environment(HomeCoordinator.self) private var coordinator
    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    public init(
        products: [Product],
        favoritedIDs: Set<String> = [],
        onFavoriteTap: ((Product) -> Void)? = nil
    ) {
        self.products = products
        self.favoritedIDs = favoritedIDs
        self.onFavoriteTap = onFavoriteTap
    }

    public var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(products) { product in
                Button(action: {
                    coordinator.push(.productDetail(productId: Int(product.id) ?? 0))
                }) {
                    ProductCardView(
                        product: product,
                        isFavorite: favoritedIDs.contains(product.id),
                        onFavoriteTap: { onFavoriteTap?(product) }
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
}
