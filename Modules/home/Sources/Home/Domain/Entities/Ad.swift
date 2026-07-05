//
//  Ad.swift
//
//
//  Ads / promotions carousel entity for the Home screen.
//  An "Ad" here is a store-driven promotional banner (e.g. products currently
//  on sale), NOT a third-party monetization ad. See AGENT.md / project docs
//  for the rationale.
//

import Foundation

public enum AdDestination: Hashable {
    case product(id: String)
    case collection(id: String?, title: String)
    case url(URL)
}

public struct Ad: Identifiable, Hashable {
    public let id: String
    public let imageURL: URL?
    public let badgeText: String?
    public let title: String
    public let subtitle: String?
    public let ctaText: String
    public let destination: AdDestination

    /// Struck-through "was" price. Real (from `compare_at_price`) when
    /// `isSynthetic == false`; a made-up markup over the real price when
    /// `isSynthetic == true`. Nil when there is no price story to tell.
    public let originalPrice: Double?
    /// The real, current selling price of the product — always accurate,
    /// even for synthetic ads.
    public let discountedPrice: Double?
    /// True when `originalPrice` was invented for display purposes (no real
    /// Shopify discount exists). Kept explicit so this can never accidentally
    /// be confused with a real markdown, and so a future dev knows exactly
    /// which UI path produced this ad.
    ///
    /// ⚠️ Do not ship `isSynthetic == true` ads to a real production store —
    /// showing an invented "original price" to real paying customers is a
    /// deceptive-pricing pattern restricted or banned outright in many
    /// jurisdictions (e.g. FTC guidance in the US, EU Omnibus Directive
    /// price-transparency rules). This exists purely so the Home screen has
    /// something lively to demo on a dev/test store with no real sale data.
    public let isSynthetic: Bool

    public init(
        id: String,
        imageURL: URL?,
        badgeText: String?,
        title: String,
        subtitle: String?,
        ctaText: String,
        destination: AdDestination,
        originalPrice: Double? = nil,
        discountedPrice: Double? = nil,
        isSynthetic: Bool = false
    ) {
        self.id = id
        self.imageURL = imageURL
        self.badgeText = badgeText
        self.title = title
        self.subtitle = subtitle
        self.ctaText = ctaText
        self.destination = destination
        self.originalPrice = originalPrice
        self.discountedPrice = discountedPrice
        self.isSynthetic = isSynthetic
    }
}

public extension Ad {
    /// Last-resort card, only used if even the plain product catalog fetch
    /// fails (e.g. no network at all). Everything above this tier uses real
    /// products.
    static let fallback = Ad(
        id: "fallback-flash-sale",
        imageURL: nil,
        badgeText: "LIMITED TIME",
        title: "Flash Sale — Up to 50% Off",
        subtitle: "Check out today's best deals",
        ctaText: "Shop Now",
        destination: .collection(id: nil, title: "All Products")
    )
}
