import Foundation
import ShopifyNetwork

struct ReviewCustomerProfileResponse: Decodable {
    let data: ReviewCustomerProfileData?
}

struct ReviewCustomerProfileData: Decodable {
    let customer: ReviewCustomerProfileDTO?
}

struct ReviewCustomerProfileDTO: Decodable {
    let firstName: String?
    let lastName: String?

    var fullName: String? {
        let name = [firstName, lastName]
            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: " ")
        return name.isEmpty ? nil : name
    }
}

struct ReviewCustomerProfileEndpoint: Endpoint {
    let customerAccessToken: String

    var baseURL: String { "https://\(ShopifyConfig.hostname)" }
    var path: String { "/api/\(ShopifyConfig.apiVersion)/graphql.json" }
    var method: String { "POST" }
    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
            "X-Shopify-Storefront-Access-Token": ShopifyConfig.storefrontToken
        ]
    }
    var queryItems: [URLQueryItem]? { nil }
    var body: Data? {
        let query = """
        query GetReviewCustomer($customerAccessToken: String!) {
          customer(customerAccessToken: $customerAccessToken) {
            firstName
            lastName
          }
        }
        """
        return try? JSONSerialization.data(withJSONObject: [
            "query": query,
            "variables": ["customerAccessToken": customerAccessToken]
        ])
    }
}
