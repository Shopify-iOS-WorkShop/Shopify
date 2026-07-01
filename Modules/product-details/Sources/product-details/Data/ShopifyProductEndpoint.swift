import Foundation

import ShopifyNetwork



public enum ShopifyProductEndpoint: Endpoint {

    case getProduct(id: Int)



    public var baseURL: String {

        return "https://mad46-ios-team5.myshopify.com/admin/api/2024-01"

    }



    public var path: String {

        switch self {

        case .getProduct(let id):

            return "/products/\(id).json"

        }

    }



    public var method: String {

        return "GET"

    }



    public var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "X-Shopify-Access-Token": "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" // 🔑 Correct key name
        ]
    }



    public var queryItems: [URLQueryItem]? {

        return nil

    }



    public var body: Data? {

        return nil

    }

}

