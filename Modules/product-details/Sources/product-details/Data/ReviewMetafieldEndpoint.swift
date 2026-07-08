import Foundation
import ShopifyNetwork

enum ReviewMetafieldEndpoint: Endpoint {
    case getReviews(productId: Int)
    case createReview(productId: Int, payload: ReviewMetafieldRequest)
    case updateReview(metafieldId: Int, payload: ReviewMetafieldRequest)
    case deleteReview(metafieldId: Int)

    var baseURL: String {
        ShopifyConfig.hostname+"/admin/api/"+ShopifyConfig.apiVersion
    }

    var path: String {
        switch self {
        case .getReviews(let productId), .createReview(let productId, _):
            return "/products/\(productId)/metafields.json"
        case .updateReview(let metafieldId, _), .deleteReview(let metafieldId):
            return "/metafields/\(metafieldId).json"
        }
    }

    var method: String {
        switch self {
        case .getReviews:
            return "GET"
        case .createReview:
            return "POST"
        case .updateReview:
            return "PUT"
        case .deleteReview:
            return "DELETE"
        }
    }

    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
            "X-Shopify-Access-Token": ShopifyConfig.accessToken
        ]
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .getReviews:
            return [URLQueryItem(name: "namespace", value: "reviews")]
        case .createReview, .updateReview, .deleteReview:
            return nil
        }
    }

    var body: Data? {
        switch self {
        case .createReview(_, let payload), .updateReview(_, let payload):
            return try? JSONEncoder().encode(payload)
        case .getReviews, .deleteReview:
            return nil
        }
    }
}
