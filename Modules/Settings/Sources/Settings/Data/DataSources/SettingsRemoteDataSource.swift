//
//  SettingsRemoteDataSource.swift
//  Settings — Data
//

import Foundation
import ShopifyNetwork

final class SettingsRemoteDataSource {
    private let networkClient: NetworkClient
    private let configuration: SettingsStorefrontConfiguration

    init(
        networkClient: NetworkClient = URLSessionNetworkClient(),
        configuration: SettingsStorefrontConfiguration = .current
    ) {
        self.networkClient = networkClient
        self.configuration = configuration
    }

    func fetchCustomerProfile(customerAccessToken: String) async throws -> CustomerProfile {
        let query = """
        query GetCustomer($customerAccessToken: String!) {
          customer(customerAccessToken: $customerAccessToken) {
            id firstName lastName email phone
            defaultAddress {
              id firstName lastName address1 city country phone
            }
            orders(first: 250, sortKey: PROCESSED_AT, reverse: true) {
              edges {
                node {
                  id orderNumber processedAt financialStatus fulfillmentStatus
                  currentTotalPrice { amount currencyCode }
                  lineItems(first: 1) {
                    edges {
                      node {
                        title quantity
                        variant { image { url } }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        """

        let response: SettingsGraphQLResponse<CustomerQueryContainer> = try await send(
            query: query,
            variables: ["customerAccessToken": customerAccessToken]
        )

        if let error = response.errors?.first?.message {
            throw SettingsError.networkError(error)
        }

        guard let customerDTO = response.data?.customer else {
            throw SettingsError.notAuthenticated
        }

        return customerDTO.toDomain()
    }

    // MARK: - Private

    private func send<T: Decodable>(query: String, variables: [String: Any]) async throws -> T {
        let body = try JSONSerialization.data(withJSONObject: [
            "query": query,
            "variables": variables
        ])

        let endpoint = SettingsGraphQLEndpoint(
            configuration: configuration,
            body: body
        )

        do {
            return try await networkClient.request(endpoint: endpoint)
        } catch let networkError as NetworkError {
            switch networkError {
            case .decodingFailed:
                throw SettingsError.decodingError
            default:
                throw SettingsError.networkError(networkError.localizedDescription)
            }
        }
    }
}

// MARK: - Endpoint

struct SettingsStorefrontConfiguration {
    let hostname: String
    let apiVersion: String
    let storefrontToken: String

    static var current: SettingsStorefrontConfiguration {
        SettingsStorefrontConfiguration(
            hostname: ShopifyConfig.hostname,
            apiVersion: ShopifyConfig.apiVersion,
            storefrontToken: ShopifyConfig.storefrontToken
        )
    }
}

private struct SettingsGraphQLEndpoint: Endpoint {
    let configuration: SettingsStorefrontConfiguration
    let body: Data?

    var baseURL: String { "https://\(configuration.hostname)" }
    var path: String { "/api/\(configuration.apiVersion)/graphql.json" }
    var method: String { "POST" }
    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
            "X-Shopify-Storefront-Access-Token": configuration.storefrontToken
        ]
    }
    var queryItems: [URLQueryItem]? { nil }
}
