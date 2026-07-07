//
//  File.swift
//  
//
//  Created by Mazen Amr on 07/07/2026.
//

import Foundation
import ShopifyNetwork

struct CreateOrderEndpoint: Endpoint {
    let payload: RESTOrderPayload
    
    var baseURL: String { "https://\(ShopifyConfig.hostname)" }
    var path: String { "/admin/api/\(ShopifyConfig.apiVersion)/orders.json" }
    var method: String { "POST" }
    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
            "X-Shopify-Access-Token": ShopifyConfig.accessToken
        ]
    }
    var queryItems: [URLQueryItem]? { nil }
    var body: Data? {
        try? JSONEncoder().encode(payload)
    }
}
