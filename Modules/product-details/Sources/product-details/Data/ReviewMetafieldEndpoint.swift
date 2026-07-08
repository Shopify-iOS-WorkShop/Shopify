import Foundation
import ShopifyNetwork

enum ReviewMetafieldEndpoint: Endpoint {
    case getReviews(productId: Int)
    case createReview(productId: Int, payload: ReviewMetafieldRequest)
    case updateReview(metafieldId: Int, payload: ReviewMetafieldRequest)
    case deleteReview(metafieldId: Int)

    var baseURL: String {
        "https://mad46-ios-team5.myshopify.com/admin/api/2024-10"
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
            "X-Shopify-Access-Token": "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"
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
