//
//  SearchResultsListView.swift
//  search
//
//  Created by Al3dwy on 02/07/2026.
//

import SwiftUI

struct SearchResultsListView: View {
    let collections: [SearchCollection]
    let products: [SearchProduct]
    var onProductTap: ((SearchProduct) -> Void)?
    var onCollectionTap: ((SearchCollection) -> Void)?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                if !collections.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Collections")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.pocketText)
                            .padding(.horizontal, 20)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(collections) { collection in
                                    CollectionCard(
                                        collection: collection,
                                        onTap: onCollectionTap
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 4)
                        }
                    }
                }

                if !products.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Products")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.pocketText)
                            .padding(.horizontal, 20)

                        VStack(spacing: 12) {
                            ForEach(products) { product in
                                ProductRow(
                                    product: product,
                                    onTap: onProductTap
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
            .padding(.top, 4)
            .padding(.bottom, 24)
        }
    }
}
