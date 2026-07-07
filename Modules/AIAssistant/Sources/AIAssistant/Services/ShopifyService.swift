//
//  ShopifyService.swift
//  AIAssistant
//
//  Created by Ahmed Elkady on 07/07/2026.
//

import Foundation

public actor ShopifyService {

    private let config: AIAssistantConfig

    public init(config: AIAssistantConfig) { self.config = config }


    public func fetchProducts(query: String? = nil, limit: Int? = nil) async throws -> [ShopifyProduct] {
        let maxItems = limit ?? config.maxProductsInContext
        let queryFilter = query.map { "query: \"\($0)\"" } ?? ""
        let gql = """
        {
          products(first: \(maxItems) \(queryFilter)) {
            edges {
              node {
                id title description handle productType tags
                priceRange {
                  minVariantPrice { amount currencyCode }
                  maxVariantPrice { amount currencyCode }
                }
                images(first: 3)   { edges { node { url altText } } }
                variants(first: 5) {
                  edges { node { id title price { amount currencyCode } availableForSale } }
                }
              }
            }
          }
        }
        """
        return try parseProducts(from: try await executeGraphQL(query: gql))
    }

    public func fetchProductsByType(_ type: String) async throws -> [ShopifyProduct] {
        try await fetchProducts(query: "product_type:\(type)")
    }

    public func fetchProductsByTag(_ tag: String) async throws -> [ShopifyProduct] {
        try await fetchProducts(query: "tag:\(tag)")
    }

    public func fetchProductsByIDs(_ ids: [String]) async throws -> [ShopifyProduct] {
        var results: [ShopifyProduct] = []
        for id in ids { if let p = try? await fetchProduct(id: id) { results.append(p) } }
        return results
    }

    public func fetchProduct(id: String) async throws -> ShopifyProduct? {
        let gid = id.hasPrefix("gid://") ? id : "gid://shopify/Product/\(id)"
        let gql = """
        {
          node(id: "\(gid)") {
            ... on Product {
              id title description handle productType tags
              priceRange {
                minVariantPrice { amount currencyCode }
                maxVariantPrice { amount currencyCode }
              }
              images(first: 3)   { edges { node { url altText } } }
              variants(first: 5) {
                edges { node { id title price { amount currencyCode } availableForSale } }
              }
            }
          }
        }
        """
        return try parseSingleProduct(from: try await executeGraphQL(query: gql))
    }

    // MARK: - GraphQL execution

    private func executeGraphQL(query: String) async throws -> Data {
        var req = URLRequest(url: config.storefrontURL)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue(config.storefrontAccessToken, forHTTPHeaderField: "X-Shopify-Storefront-Access-Token")
        req.httpBody = try JSONEncoder().encode(["query": query])
        let (data, response) = try await URLSession.shared.data(for: req)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw AIAssistantError.shopifyError("HTTP \((response as? HTTPURLResponse)?.statusCode ?? -1)")
        }
        return data
    }

    // MARK: - Parsing

    private func parseProducts(from data: Data) throws -> [ShopifyProduct] {
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard let edges = (json?["data"] as? [String: Any])?["products"]
                .flatMap({ ($0 as? [String: Any])?["edges"] as? [[String: Any]] }) else { return [] }
        return edges.compactMap { ($0["node"] as? [String: Any]).flatMap(parseProductNode) }
    }

    private func parseSingleProduct(from data: Data) throws -> ShopifyProduct? {
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard let node = (json?["data"] as? [String: Any])?["node"] as? [String: Any] else { return nil }
        return parseProductNode(node)
    }

    private func parseProductNode(_ node: [String: Any]) -> ShopifyProduct? {
        guard let id = node["id"] as? String, let title = node["title"] as? String else { return nil }
        return ShopifyProduct(
            id: id, title: title,
            description: node["description"] as? String ?? "",
            handle: node["handle"] as? String ?? "",
            productType: node["productType"] as? String ?? "",
            tags: node["tags"] as? [String] ?? [],
            priceRange: parsePriceRange(node["priceRange"] as? [String: Any]),
            images: parseImages(node["images"] as? [String: Any]),
            variants: parseVariants(node["variants"] as? [String: Any])
        )
    }

    private func parsePriceRange(_ d: [String: Any]?) -> PriceRange {
        func m(_ k: [String: Any]?) -> MoneyV2 { MoneyV2(amount: k?["amount"] as? String ?? "0.00", currencyCode: k?["currencyCode"] as? String ?? "USD") }
        return PriceRange(minVariantPrice: m(d?["minVariantPrice"] as? [String: Any]), maxVariantPrice: m(d?["maxVariantPrice"] as? [String: Any]))
    }

    private func parseImages(_ d: [String: Any]?) -> [ProductImage] {
        (d?["edges"] as? [[String: Any]] ?? []).compactMap {
            guard let n = $0["node"] as? [String: Any], let url = n["url"] as? String else { return nil }
            return ProductImage(url: url, altText: n["altText"] as? String)
        }
    }

    private func parseVariants(_ d: [String: Any]?) -> [ProductVariant] {
        (d?["edges"] as? [[String: Any]] ?? []).compactMap {
            guard let n = $0["node"] as? [String: Any],
                  let id = n["id"] as? String, let title = n["title"] as? String else { return nil }
            let pd = n["price"] as? [String: Any]
            return ProductVariant(id: id, title: title,
                price: MoneyV2(amount: pd?["amount"] as? String ?? "0.00", currencyCode: pd?["currencyCode"] as? String ?? "USD"),
                availableForSale: n["availableForSale"] as? Bool ?? true)
        }
    }
}
