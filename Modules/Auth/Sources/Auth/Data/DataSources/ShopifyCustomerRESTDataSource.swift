import Foundation
import ShopifyNetwork

/// REST API-based data source for Shopify customer operations
/// Uses Admin API with basic authentication (no password required for customer creation)
final class ShopifyCustomerRESTDataSource {
    private let networkClient: NetworkClient
    private let apiKey: String
    private let accessToken: String
    private let hostname: String
    private let apiVersion: String
    
    init(
        networkClient: NetworkClient = URLSessionNetworkClient(),
        apiKey: String = ShopifyConfig.apiKey,
        accessToken: String = ShopifyConfig.accessToken,
        hostname: String = ShopifyConfig.hostname,
        apiVersion: String = ShopifyConfig.apiVersion
    ) {
        self.networkClient = networkClient
        self.apiKey = apiKey
        self.accessToken = accessToken
        self.hostname = hostname
        self.apiVersion = apiVersion
    }
    
    // MARK: - Customer Operations
    
    /// Create a new customer via REST API (no password required)
    /// - Parameters:
    ///   - email: Customer email
    ///   - firstName: Customer first name
    ///   - lastName: Customer last name
    ///   - verifiedEmail: Whether the email has been verified (default: true after Firebase verification)
    /// - Returns: Shopify customer ID
    func createCustomer(
        email: String,
        firstName: String,
        lastName: String,
        verifiedEmail: Bool = true
    ) async throws -> String {
        let body: [String: Any] = [
            "customer": [
                "first_name": firstName,
                "last_name": lastName,
                "email": email,
                "verified_email": verifiedEmail,
                "send_email_welcome": false
            ]
        ]
        
        let endpoint = ShopifyAdminRESTEndpoint(
            baseURL: buildBaseURL(),
            path: "/admin/api/\(apiVersion)/customers.json",
            method: "POST",
            body: try? JSONSerialization.data(withJSONObject: body)
        )
        
        let response: CustomerCreateRESTResponse = try await networkClient.request(endpoint: endpoint)
        
        guard let customerId = response.customer.id else {
            throw AuthError.shopify("Failed to create customer")
        }
        
        return String(customerId)
    }
    
    /// Find customer by email (used for login)
    /// - Parameter email: Customer email
    /// - Returns: Shopify customer ID if found
    func findCustomerByEmail(_ email: String) async throws -> String? {
        let encodedEmail = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? email
        let endpoint = ShopifyAdminRESTEndpoint(
            baseURL: buildBaseURL(),
            path: "/admin/api/\(apiVersion)/customers/search.json",
            method: "GET",
            queryItems: [URLQueryItem(name: "query", value: "email:\(encodedEmail)")]
        )
        
        let response: CustomerSearchRESTResponse = try await networkClient.request(endpoint: endpoint)
        
        guard let customer = response.customers.first,
              let customerId = customer.id else {
            return nil
        }
        
        return String(customerId)
    }
    
    /// Get customer details by ID
    /// - Parameter customerId: Shopify customer ID
    /// - Returns: Customer information
    func getCustomer(customerId: String) async throws -> RESTCustomer {
        let endpoint = ShopifyAdminRESTEndpoint(
            baseURL: buildBaseURL(),
            path: "/admin/api/\(apiVersion)/customers/\(customerId).json",
            method: "GET"
        )
        
        let response: CustomerGetRESTResponse = try await networkClient.request(endpoint: endpoint)
        return response.customer
    }
    
    // MARK: - Helper Methods
    
    private func buildBaseURL() -> String {
        "https://\(apiKey):\(accessToken)@\(hostname)"
    }
}

// MARK: - REST Endpoint

struct ShopifyAdminRESTEndpoint: Endpoint {
    let baseURL: String
    let path: String
    let method: String
    var body: Data?
    var queryItems: [URLQueryItem]?
    
    var headers: [String: String]? {
        if method == "POST" || method == "PUT" {
            return ["Content-Type": "application/json"]
        }
        return nil
    }
}

// MARK: - REST Response Models

struct CustomerCreateRESTResponse: Decodable {
    let customer: RESTCustomer
}

struct CustomerSearchRESTResponse: Decodable {
    let customers: [RESTCustomer]
}

struct CustomerGetRESTResponse: Decodable {
    let customer: RESTCustomer
}

struct RESTCustomer: Decodable {
    let id: Int?
    let email: String?
    let firstName: String?
    let lastName: String?
    let verifiedEmail: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case verifiedEmail = "verified_email"
    }
}
