//
//  SwiftUIView.swift
//  search
//
//  Created by Al3dwy on 02/07/2026.
//

import SwiftUI

struct SearchResultsListView: View {
    let collections: [SearchCollection]
    let products: [SearchProduct]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                if !collections.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Collections")
                            .font(.system(size: 16, weight: .bold))
                            .padding(.horizontal, 20)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(collections) { collection in
                                    CollectionCard(collection: collection)
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
                            .padding(.horizontal, 20)

                        VStack(spacing: 12) {
                            ForEach(products) { product in
                                ProductRow(product: product)
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
