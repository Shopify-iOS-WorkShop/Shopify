//
//  HomeEndpoint.swift
//  Home
//
//  Uses Admin REST API for products and collections
//

import Foundation
import ShopifyNetwork

enum HomeEndpoint: Endpoint {
    case getProducts
    case getProductDetails(id: String)
    case getSmartCollections
    case getCustomCollections
    /// Looks up a custom collection by its exact title (e.g. "SALE"), so we
    /// can find its id without hardcoding one.
    case getCollectionByTitle(String)
    /// Products inside a given collection — reused to pull everything
    /// currently sitting in the SALE collection for the ads carousel.
    case getProductsInCollection(id: String)
    
    var baseURL: String {
        return "https://\(ShopifyConfig.hostname)/admin/api/\(ShopifyConfig.apiVersion)"
    }
    
    var path: String {
        switch self {
        case .getProducts, .getProductsInCollection:
            return "/products.json"
        case .getProductDetails(let id):
            return "/products/\(id).json"
        case .getSmartCollections:
            return "/smart_collections.json"
        case .getCustomCollections, .getCollectionByTitle:
            return "/custom_collections.json"
        }
    }
    
    var method: String {
        return "GET"
    }
    
    var headers: [String: String]? {
        return [
            "X-Shopify-Access-Token": ShopifyConfig.accessToken,
            "Content-Type": "application/json"
        ]
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getCollectionByTitle(let title):
            return [URLQueryItem(name: "title", value: title)]
        case .getProductsInCollection(let id):
            return [
                URLQueryItem(name: "collection_id", value: id),
                URLQueryItem(name: "status", value: "active")
            ]
        default:
            return nil
        }
    }
    
    var body: Data? {
        return nil
    }
}
