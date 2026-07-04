 
 //
//  File.swift
//  
//
//  Created by Mazen Amr on 27/06/2026.
//

import Foundation
import ShopifyNetwork

public class HomeRepository: HomeRepositoryProtocol {
    private let networkClient: NetworkClient
    
    public init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    public func fetchBestSellers() async throws -> [Product] {
        let response: ShopifyProductResponse = try await networkClient.request(endpoint: HomeEndpoint.getProducts)
        return response.products.map { $0.toDomain() }
    }
    public func fetchBrands() async throws -> [Brand] {
        let response: SmartCollectionResponse = try await networkClient.request(endpoint: HomeEndpoint.getSmartCollections)
        return response.smart_collections.map { $0.toBrand() }
    }
    
    public func fetchCategories() async throws -> [Category] {
        let response: CustomCollectionResponse = try await networkClient.request(endpoint: HomeEndpoint.getCustomCollections)
        return response.custom_collections.map { $0.toCategory() }
    }

    // MARK: - Ads
    //
    // There is no Shopify "ads" API — Shopify's own Ads product is for
    // merchants running Google/Facebook campaigns, not for serving banners
    // inside a storefront app. Instead we derive ads from real store data,
    // in two tiers:
    //
    //   1. Real discounts — products in the existing "SALE" collection
    //      (already used for the Categories grid) that have an active
    //      discount (compare_at_price > price). 100% truthful, zero new
    //      backend setup, self-updates when merchandising changes SALE.
    //
    //   2. Synthetic promos — if the store currently has no SALE-collection
    //      discounts (e.g. a fresh dev/test store), we fall back to real
    //      catalog products with an invented "was" price so Home always has
    //      a lively, tappable carousel instead of one static banner forever.
    //      Real image, real title, real current price, real navigation —
    //      only the struck-through price is made up. See `Ad.isSynthetic`
    //      doc comment: do not ship tier 2 to a real production store.
    //
    // `Ad.fallback` (a fully static card) is now only a last resort if even
    // the plain product catalog request fails.
    public func fetchAds() async throws -> [Ad] {
        if let realAds = try? await fetchRealSaleAds(), !realAds.isEmpty {
            return realAds
        }
        return try await fetchSyntheticAds()
    }

    private func fetchRealSaleAds() async throws -> [Ad] {
        guard let saleCollectionId = try await fetchSaleCollectionId() else {
            return []
        }

        let response: ShopifyProductResponse = try await networkClient.request(
            endpoint: HomeEndpoint.getProductsInCollection(id: saleCollectionId)
        )

        let ads = response.products
            .compactMap { $0.toAdCandidate() }
            .sorted { $0.discountPercent > $1.discountPercent }
            .prefix(5)
            .map { $0.toAd() }

        return Array(ads)
    }

    private func fetchSyntheticAds() async throws -> [Ad] {
        let response: ShopifyProductResponse = try await networkClient.request(endpoint: HomeEndpoint.getProducts)

        let ads = response.products
            .compactMap { $0.toSyntheticAdCandidate() }
            .prefix(5)
            .map { $0.toAd() }

        return Array(ads)
    }

    private func fetchSaleCollectionId() async throws -> String? {
        let response: CustomCollectionResponse = try await networkClient.request(
            endpoint: HomeEndpoint.getCollectionByTitle("SALE")
        )
        return response.custom_collections.first.map { String($0.id) }
    }
}
