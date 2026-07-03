import Foundation
import ShopifyNetwork

struct ShopifyCustomerCredentials {
    let email: String
    let password: String
}

struct ShopifyCustomerName {
    let firstName: String
    let lastName: String
}

final class ShopifyCustomerDataSource {
    private let networkClient: NetworkClient
    private let configuration: ShopifyStorefrontConfiguration
    private let storefrontToken: String

    init(
        networkClient: NetworkClient = URLSessionNetworkClient(),
        configuration: ShopifyStorefrontConfiguration = .current,
        storefrontToken: String = ShopifyStorefrontConfiguration.current.storefrontToken
    ) {
        self.networkClient = networkClient
        self.configuration = configuration
        self.storefrontToken = storefrontToken
    }

    func createCustomer(credentials: ShopifyCustomerCredentials, name: ShopifyCustomerName) async throws -> String? {
        let query = """
        mutation RegisterCustomer($input: CustomerCreateInput!) {
          customerCreate(input: $input) {
            customer { id firstName lastName email }
            customerUserErrors { code field message }
          }
        }
        """

        let variables: [String: Any] = [
            "input": [
                "email": credentials.email,
                "password": credentials.password,
                "firstName": name.firstName,
                "lastName": name.lastName
            ]
        ]

        let response: GraphQLResponse<CustomerCreateContainer> = try await send(query: query, variables: variables)
        if let message = response.data?.customerCreate.customerUserErrors.first?.message {
            throw AuthError.shopify(message)
        }

        return response.data?.customerCreate.customer?.id
    }

    func createAccessToken(credentials: ShopifyCustomerCredentials, firebaseUID: String, customerId: String? = nil) async throws -> Session {
        let query = """
        mutation LoginCustomer($input: CustomerAccessTokenCreateInput!) {
          customerAccessTokenCreate(input: $input) {
            customerAccessToken { accessToken expiresAt }
            customerUserErrors { code field message }
          }
        }
        """

        let variables: [String: Any] = [
            "input": [
                "email": credentials.email,
                "password": credentials.password
            ]
        ]

        let response: GraphQLResponse<CustomerAccessTokenCreateContainer> = try await send(query: query, variables: variables)
        if let message = response.data?.customerAccessTokenCreate.customerUserErrors.first?.message {
            throw AuthError.shopify(message)
        }

        guard let token = response.data?.customerAccessTokenCreate.customerAccessToken else {
            throw AuthError.shopify("Shopify did not return a customer access token.")
        }

        return Session(
            customerAccessToken: token.accessToken,
            expiresAt: token.expiresAt,
            customerId: customerId,
            firebaseUID: firebaseUID
        )
    }

    func deleteAccessToken(_ customerAccessToken: String) async throws {
        let query = """
        mutation LogoutCustomer($customerAccessToken: String!) {
          customerAccessTokenDelete(customerAccessToken: $customerAccessToken) {
            deletedAccessToken
            deletedCustomerAccessTokenId
            userErrors { field message }
          }
        }
        """

        let response: GraphQLResponse<CustomerAccessTokenDeleteContainer> = try await send(
            query: query,
            variables: ["customerAccessToken": customerAccessToken]
        )
        if let message = response.data?.customerAccessTokenDelete.userErrors.first?.message {
            throw AuthError.shopify(message)
        }
    }

    func recoverPassword(email: String) async throws {
        let query = """
        mutation RecoverPassword($email: String!) {
          customerRecover(email: $email) {
            customerUserErrors { code field message }
          }
        }
        """

        let response: GraphQLResponse<CustomerRecoverContainer> = try await send(
            query: query,
            variables: ["email": email]
        )
        if let message = response.data?.customerRecover.customerUserErrors.first?.message {
            throw AuthError.shopify(message)
        }
    }

    private func send<T: Decodable>(query: String, variables: [String: Any]) async throws -> GraphQLResponse<T> {
        guard !storefrontToken.isEmpty else {
            throw AuthError.shopify("Storefront access token is not configured.")
        }

        let endpoint = AuthShopifyGraphQLEndpoint(
            configuration: configuration,
            storefrontToken: storefrontToken,
            body: try JSONSerialization.data(withJSONObject: [
                "query": query,
                "variables": variables
            ])
        )
        let graphQLResponse: GraphQLResponse<T> = try await networkClient.request(endpoint: endpoint)
        if let message = graphQLResponse.errors?.first?.message {
            throw AuthError.shopify(message)
        }

        return graphQLResponse
    }
}

struct AuthShopifyGraphQLEndpoint: Endpoint {
    let configuration: ShopifyStorefrontConfiguration
    let storefrontToken: String
    let body: Data?

    var baseURL: String {
        "https://\(configuration.hostname)"
    }

    var path: String {
        "/api/\(configuration.apiVersion)/graphql.json"
    }

    var method: String {
        "POST"
    }

    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
            "X-Shopify-Storefront-Access-Token": storefrontToken
        ]
    }

    var queryItems: [URLQueryItem]? {
        nil
    }
}

struct ShopifyStorefrontConfiguration {
    let hostname: String
    let apiVersion: String
    let storefrontToken: String

    static var current: ShopifyStorefrontConfiguration {
//        let info = Bundle.main.infoDictionary ?? [:]
//        
//        let token = info["SHOPIFY_STOREFRONT_TOKEN"] as? String ?? ""
//        let finalToken = token.hasPrefix("$(") ? "" : token
        return ShopifyStorefrontConfiguration(
            hostname: ShopifyConfig.hostname,
            apiVersion: ShopifyConfig.apiVersion,
            storefrontToken: ShopifyConfig.storefrontToken
        )
    }
}

private struct GraphQLResponse<T: Decodable>: Decodable {
    let data: T?
    let errors: [GraphQLTopLevelError]?
}

private struct GraphQLTopLevelError: Decodable {
    let message: String
}

private struct CustomerUserError: Decodable {
    let message: String
}

private struct UserError: Decodable {
    let message: String
}

private struct CustomerCreateContainer: Decodable {
    let customerCreate: CustomerCreatePayload
}

private struct CustomerCreatePayload: Decodable {
    let customer: CustomerPayload?
    let customerUserErrors: [CustomerUserError]
}

private struct CustomerPayload: Decodable {
    let id: String
}

private struct CustomerAccessTokenCreateContainer: Decodable {
    let customerAccessTokenCreate: CustomerAccessTokenCreatePayload
}

private struct CustomerAccessTokenCreatePayload: Decodable {
    let customerAccessToken: CustomerAccessTokenPayload?
    let customerUserErrors: [CustomerUserError]
}

private struct CustomerAccessTokenPayload: Decodable {
    let accessToken: String
    let expiresAt: Date

    private enum CodingKeys: String, CodingKey {
        case accessToken
        case expiresAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        let expiresAtString = try container.decode(String.self, forKey: .expiresAt)
        guard let date = ISO8601DateFormatter().date(from: expiresAtString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .expiresAt,
                in: container,
                debugDescription: "Invalid ISO8601 date."
            )
        }
        expiresAt = date
    }
}

private struct CustomerAccessTokenDeleteContainer: Decodable {
    let customerAccessTokenDelete: CustomerAccessTokenDeletePayload
}

private struct CustomerAccessTokenDeletePayload: Decodable {
    let userErrors: [UserError]
}

private struct CustomerRecoverContainer: Decodable {
    let customerRecover: CustomerRecoverPayload
}

private struct CustomerRecoverPayload: Decodable {
    let customerUserErrors: [CustomerUserError]
}
