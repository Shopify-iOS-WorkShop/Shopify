import Foundation
import ShopifyNetwork

/// REST API-based data source for Shopify customer operations
/// Uses Admin API with basic authentication (no password required for customer creation)
final class ShopifyCustomerRESTDataSource {
    private let networkClient: NetworkClient
    private let accessToken: String
    private let hostname: String
    private let apiVersion: String
    
    init(
        networkClient: NetworkClient = URLSessionNetworkClient(),
        accessToken: String = ShopifyConfig.accessToken,
        hostname: String = ShopifyConfig.hostname,
        apiVersion: String = ShopifyConfig.apiVersion
    ) {
        self.networkClient = networkClient
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
        password: String,
        verifiedEmail: Bool = true
    ) async throws -> String {
        let body: [String: Any] = [
            "customer": [
                "first_name": firstName,
                "last_name": lastName,
                "email": email,
                "password": password,
                "password_confirmation": password,
                "verified_email": verifiedEmail,
                "send_email_welcome": false
            ]
        ]
        
        let endpoint = ShopifyAdminRESTEndpoint(
            baseURL: buildBaseURL(),
            path: "/admin/api/\(apiVersion)/customers.json",
            method: "POST",
            body: try? JSONSerialization.data(withJSONObject: body),
            accessToken: accessToken
        )
        
        let response: CustomerCreateRESTResponse = try await networkClient.request(endpoint: endpoint)
        
        guard let customerId = response.customer.id else {
            throw AuthError.shopify("Failed to create customer")
        }
        
        return String(customerId)
    }

    func updateCustomerPassword(customerId: String, password: String) async throws {
        let body: [String: Any] = [
            "customer": [
                "id": customerId,
                "password": password,
                "password_confirmation": password
            ]
        ]

        let endpoint = ShopifyAdminRESTEndpoint(
            baseURL: buildBaseURL(),
            path: "/admin/api/\(apiVersion)/customers/\(customerId).json",
            method: "PUT",
            body: try? JSONSerialization.data(withJSONObject: body),
            accessToken: accessToken
        )

        let _: CustomerGetRESTResponse = try await networkClient.request(endpoint: endpoint)
    }
    
    /// Find customer by email (used for login)
    /// - Parameter email: Customer email
    /// - Returns: Shopify customer ID if found
    func findCustomerByEmail(_ email: String) async throws -> String? {
        let endpoint = ShopifyAdminRESTEndpoint(
            baseURL: buildBaseURL(),
            path: "/admin/api/\(apiVersion)/customers/search.json",
            method: "GET",
            queryItems: [URLQueryItem(name: "query", value: "email:\(email)")],
            accessToken: accessToken
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
            method: "GET",
            accessToken: accessToken
        )
        
        let response: CustomerGetRESTResponse = try await networkClient.request(endpoint: endpoint)
        return response.customer
    }
    
    // MARK: - Helper Methods
    
    private func buildBaseURL() -> String {
        "https://\(hostname)"
    }
}

// MARK: - REST Endpoint

struct ShopifyAdminRESTEndpoint: Endpoint {
    let baseURL: String
    let path: String
    let method: String
    var body: Data?
    var queryItems: [URLQueryItem]?
    let accessToken: String
    
    var headers: [String: String]? {
        var values = ["X-Shopify-Access-Token": accessToken]
        if method == "POST" || method == "PUT" {
            values["Content-Type"] = "application/json"
        }
        return values
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
