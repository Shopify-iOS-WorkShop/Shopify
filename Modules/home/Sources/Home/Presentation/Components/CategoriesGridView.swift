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
    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    public init(categories: [Category]) {
        self.categories = categories
    }

    public var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(categories) { category in
                CategoryCardView(category: category)
            }
        }
    }
}
