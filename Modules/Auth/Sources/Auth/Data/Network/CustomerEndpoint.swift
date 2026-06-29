//
//  CustomerEndpoint.swift
//  Auth
//

import Foundation
import ShopifyNetwork

enum CustomerEndpoint: Endpoint {
    case createCustomer(firstName: String?, lastName: String?, email: String)
    case searchCustomerByEmail(email: String)

    var baseURL: String {
        return "https://\(ShopifyConfig.hostname)/admin/api/\(ShopifyConfig.apiVersion)"
    }

    var path: String {
        switch self {
        case .createCustomer:
            return "/customers.json"
        case .searchCustomerByEmail:
            return "/customers/search.json"
        }
    }

    var method: String {
        switch self {
        case .createCustomer:
            return "POST"
        case .searchCustomerByEmail:
            return "GET"
        }
    }

    var headers: [String: String]? {
        let authString = "\(ShopifyConfig.apiKey):\(ShopifyConfig.accessToken)"
        let authData = authString.data(using: .utf8)!
        let base64AuthString = authData.base64EncodedString()
        return [
            "Content-Type": "application/json",
            "Authorization": "Basic \(base64AuthString)"
        ]
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .createCustomer:
            return nil
        case .searchCustomerByEmail(let email):
            return [URLQueryItem(name: "query", value: "email:\(email)")]
        }
    }

    var body: Data? {
        switch self {
        case .createCustomer(let firstName, let lastName, let email):
            let payload: [String: Any] = [
                "customer": [
                    "first_name": firstName ?? "",
                    "last_name": lastName ?? "",
                    "email": email,
                    "verified_email": true,
                    "send_email_welcome": false
                ] as [String : Any]
            ]
            return try? JSONSerialization.data(withJSONObject: payload, options: [])
        case .searchCustomerByEmail:
            return nil
        }
    }
}
