//
//  ShopifyAuthDataSource.swift
//  Auth
//

import Foundation
import ShopifyNetwork

class ShopifyAuthDataSource {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = URLSessionNetworkClient()) {
        self.networkClient = networkClient
    }

    func syncUser(email: String, firstName: String? = nil, lastName: String? = nil) async throws -> String {
        // 1. Try to search by email
        let searchEndpoint = CustomerEndpoint.searchCustomerByEmail(email: email)
        do {
            let searchResponse: CustomersSearchResponse = try await networkClient.request(endpoint: searchEndpoint)
            if let existingCustomer = searchResponse.customers.first {
                return String(existingCustomer.id)
            }
        } catch {
            // Ignore search error and try to create
        }
        
        // 2. If not found or error occurred, try to create a new customer
        let createEndpoint = CustomerEndpoint.createCustomer(firstName: firstName, lastName: lastName, email: email)
        let createResponse: CustomerResponse = try await networkClient.request(endpoint: createEndpoint)
        
        return String(createResponse.customer.id)
    }
}
