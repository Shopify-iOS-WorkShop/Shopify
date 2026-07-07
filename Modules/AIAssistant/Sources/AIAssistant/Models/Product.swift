//
//  Product.swift
//  AIAssistant
//
//  Created by Ahmed Elkady on 07/07/2026.
//

import Foundation

public struct ShopifyProduct: Codable, Identifiable, Sendable {
    public let id: String
    public let title: String
    public let description: String
    public let handle: String
    public let productType: String
    public let tags: [String]
    public let priceRange: PriceRange
    public let images: [ProductImage]
    public let variants: [ProductVariant]

    public var firstImageURL: URL? { images.first.flatMap { URL(string: $0.url) } }
    public var minPrice: String    { priceRange.minVariantPrice.formattedAmount }
    public var maxPrice: String    { priceRange.maxVariantPrice.formattedAmount }

    public var aiContext: String {
        """
        Product: \(title)
        Type: \(productType)
        Tags: \(tags.joined(separator: ", "))
        Price: \(minPrice)\(minPrice != maxPrice ? " – \(maxPrice)" : "")
        Description: \(description.prefix(300))
        """
    }
}

public struct PriceRange: Codable, Sendable {
    public let minVariantPrice: MoneyV2
    public let maxVariantPrice: MoneyV2
}

public struct MoneyV2: Codable, Sendable {
    public let amount: String
    public let currencyCode: String
    public var formattedAmount: String { "\(currencyCode) \(amount)" }
}

public struct ProductImage: Codable, Sendable {
    public let url: String
    public let altText: String?
}

public struct ProductVariant: Codable, Identifiable, Sendable {
    public let id: String
    public let title: String
    public let price: MoneyV2
    public let availableForSale: Bool
}
