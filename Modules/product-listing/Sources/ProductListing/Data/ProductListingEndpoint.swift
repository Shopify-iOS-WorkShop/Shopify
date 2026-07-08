import Foundation
import ShopifyNetwork

public enum ProductListingEndpoint: Endpoint {
    case allProducts
    case collectionProducts(id: String)

    public var baseURL: String {
        return "https://\(ShopifyConfig.hostname)/admin/api/\(ShopifyConfig.apiVersion)"
    }

    public var path: String {
        switch self {
        case .allProducts, .collectionProducts:
            return "/products.json"
        }
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

    public var queryItems: [URLQueryItem]? {
        switch self {
        case .collectionProducts(let id):
            let numericId = id.components(separatedBy: "/").last ?? id
            return [URLQueryItem(name: "collection_id", value: numericId)]
        case .allProducts:
            return nil
        }
    }

    public var body: Data? {
        return nil
    }
}
