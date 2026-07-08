//
//  File.swift
//  
//
//  Created by Mazen Amr on 28/06/2026.
//

import Foundation

struct ShopifyProductResponse: Decodable {
    let products: [ShopifyProductDTO]
}

struct ShopifyProductDTO: Decodable {
    let id: Int
    let title: String
    let vendor: String
    let variants: [VariantDTO]?
    let image: ImageDTO?
    
    struct VariantDTO: Decodable {
        let price: String
        let compare_at_price: String?
    }
    
    struct ImageDTO: Decodable {
        let src: String
    }
    
   
    func toDomain() -> Product {
        return Product(
            id: String(id),
            title: title,
            vendor: vendor,
            price: Double(variants?.first?.price ?? "0.0") ?? 0.0,
            rating: 4.5,
            imageURL: URL(string: image?.src ?? "")
        )
    }

    /// A product only becomes ad-worthy when it has a real, active discount:
    /// `compare_at_price` set and strictly greater than the selling `price`.
    /// Returns nil for anything else so plain full-price products never show
    /// up as a "sale" banner.
    func toAdCandidate() -> AdCandidate? {
        guard let variant = variants?.first,
              let price = Double(variant.price),
              let compareRaw = variant.compare_at_price,
              let compareAt = Double(compareRaw),
              compareAt > price,
              price > 0 else {
            return nil
        }

        let percentOff = Int(((compareAt - price) / compareAt) * 100)
        guard percentOff > 0 else { return nil }

        return AdCandidate(
            productId: String(id),
            title: title,
            imageURL: URL(string: image?.src ?? ""),
            discountPercent: percentOff,
            realPrice: price,
            originalPrice: compareAt,
            isSynthetic: false
        )
    }

    /// Fallback path used only when the store has zero real discounts to
    /// show. Takes a normal, full-price product and invents a "was" price
    /// above the real one so the Home carousel always has something to
    /// demo, without ever changing the real price the user actually pays.
    ///
    /// The markup is derived deterministically from the product id (not
    /// `Int.random`) so the same product shows the same synthetic discount
    /// on every launch instead of flickering to a different number each
    /// time Home reloads.
    ///
    /// ⚠️ Synthetic only — see `Ad.isSynthetic` doc comment before reusing
    /// this on a real production store.
    func toSyntheticAdCandidate() -> AdCandidate? {
        guard let variant = variants?.first,
              let price = Double(variant.price),
              price > 0,
              let src = image?.src, !src.isEmpty,
              let imageURL = URL(string: src) else {
            return nil
        }

        let markupPercent = 20 + (id % 26) // deterministic 20%–45% range
        let fakeOriginalPrice = price * (100.0 + Double(markupPercent)) / 100.0

        return AdCandidate(
            productId: String(id),
            title: title,
            imageURL: imageURL,
            discountPercent: Int(markupPercent),
            realPrice: price,
            originalPrice: fakeOriginalPrice,
            isSynthetic: true
        )
    }

    struct AdCandidate {
        let productId: String
        let title: String
        let imageURL: URL?
        let discountPercent: Int
        let realPrice: Double
        let originalPrice: Double
        let isSynthetic: Bool

        func toAd() -> Ad {
            Ad(
                id: "\(isSynthetic ? "promo" : "sale")-\(productId)",
                imageURL: imageURL,
                badgeText: "-\(discountPercent)%",
                title: title,
                subtitle: isSynthetic ? "Today's pick for you" : "Limited time offer",
                ctaText: "Shop Now",
                destination: .product(id: productId),
                originalPrice: originalPrice,
                discountedPrice: realPrice,
                isSynthetic: isSynthetic
            )
        }
    }
}
