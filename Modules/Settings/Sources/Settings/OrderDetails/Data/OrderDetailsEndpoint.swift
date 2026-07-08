//
//  File.swift
//  
//
//  Created by Mazen Amr on 07/07/2026.
//

import Foundation
import ShopifyNetwork

public struct OrderDetailsEndpoint: Endpoint {
    let orderId: String
    
    public init(orderId: String) {
        self.orderId = orderId
    }
    
    public var baseURL: String {
        return "https://\(ShopifyConfig.hostname)"
    }
    
    public var path: String {
        return "/admin/api/\(ShopifyConfig.apiVersion)/orders/\(orderId).json"
    }
    
    public var method: String {
        return "GET"
    }
    
    public var headers: [String: String]? {
        return [
            "X-Shopify-Access-Token": ShopifyConfig.accessToken,
            "Content-Type": "application/json"
        ]
    }
    
    public var queryItems: [URLQueryItem]? { return nil }
    public var body: Data? { return nil }
}
