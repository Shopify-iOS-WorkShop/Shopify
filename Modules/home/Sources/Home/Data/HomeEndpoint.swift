//
//  File.swift
//  
//
//  Created by Mazen Amr on 27/06/2026.
//

import Foundation
import ShopifyNetwork

enum HomeEndpoint: Endpoint {
    case getProducts
    case getProductDetails(id: String)
    case getSmartCollections
    case getCustomCollections
    
    var baseURL: String {
        return "https://\(ShopifyConfig.apiKey):\(ShopifyConfig.accessToken)@\(ShopifyConfig.hostname)/admin/api/\(ShopifyConfig.apiVersion)"
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
        return ["Content-Type": "application/json"]
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        return nil
    }
}
