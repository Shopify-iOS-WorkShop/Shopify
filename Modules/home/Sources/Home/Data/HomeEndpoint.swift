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
    
    var baseURL: String {
        return "https://\(ShopifyConfig.hostname)/admin/api/\(ShopifyConfig.apiVersion)"
    }
    
    var path: String {
        switch self {
        case .getProducts:
            return "/products.json"
        case .getProductDetails(let id):
            return "/products/\(id).json"
        case .getSmartCollections:
            return "/smart_collections.json"
        case .getCustomCollections:
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
        return nil
    }
    
    var body: Data? {
        return nil
    }
}
