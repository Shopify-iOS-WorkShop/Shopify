//
//  File.swift
//  
//
//  Created by Mazen Amr on 27/06/2026.
//

import Foundation
import SwiftUI

public struct CategoriesGridView: View {
    public let categories: [Category]
    @Environment(HomeCoordinator.self) private var coordinator
    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    public init(categories: [Category]) {
        self.categories = categories
    }

    public var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(categories) { category in
                Button(action: {
                    coordinator.push(.productListing(collectionId: category.id, title: category.title))
                }) {
                    CategoryCardView(category: category)
                }
                .buttonStyle(.plain)
            }
        }
    }
}
