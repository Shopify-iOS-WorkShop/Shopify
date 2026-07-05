//
//  AddressGraphQLEndpoint.swift
//  Address
//
//  Created by Mina Nashaat on 05/07/2026.
//

import Foundation
import ShopifyNetwork

struct AddressGraphQLEndpoint<Variables: Encodable>: Endpoint {

    private struct RequestBody: Encodable {
        let query: String
        let variables: Variables
    }

    let query: String
    let variables: Variables

    var baseURL: String { "https://\(ShopifyConfig.hostname)" }
    var path: String { "/api/\(ShopifyConfig.apiVersion)/graphql.json" }
    var method: String { "POST" }

    var headers: [String: String]? {
        [
            "X-Shopify-Storefront-Access-Token": ShopifyConfig.storefrontToken,
            "Content-Type": "application/json"
        ]
    }

    var queryItems: [URLQueryItem]? { nil }

    var body: Data? {
        try? JSONEncoder().encode(RequestBody(query: query, variables: variables))
    }
}

struct MailingAddressInputDTO: Encodable {
    var firstName: String?
    var lastName: String?
    var address1: String?
    var address2: String?
    var city: String?
    var country: String?
    var province: String?
    var zip: String?
    var phone: String?
}

struct CreateAddressVariables: Encodable {
    let customerAccessToken: String
    let address: MailingAddressInputDTO
}

struct UpdateAddressVariables: Encodable {
    let customerAccessToken: String
    let id: String
    let address: MailingAddressInputDTO
}

struct DeleteAddressVariables: Encodable {
    let customerAccessToken: String
    let id: String
}

struct FetchAddressesVariables: Encodable {
    let customerAccessToken: String
}

struct SetDefaultAddressVariables: Encodable {
    let customerAccessToken: String
    let addressId: String
}
