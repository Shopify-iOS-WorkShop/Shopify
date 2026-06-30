//
//  DraftOrderEndpoint.swift
//  Cart
//

import Foundation
import ShopifyNetwork

public enum DraftOrderEndpoint: Endpoint {
    case createDraftOrder(payload: [String: Any])
    case getDraftOrder(id: String)
    case updateDraftOrder(id: String, payload: [String: Any])
    case deleteDraftOrder(id: String)

    public var baseURL: String {
        return "https://\(ShopifyConfig.hostname)/admin/api/\(ShopifyConfig.apiVersion)"
    }

    public var path: String {
        switch self {
        case .createDraftOrder:
            return "/draft_orders.json"
        case .getDraftOrder(let id):
            return "/draft_orders/\(id).json"
        case .updateDraftOrder(let id, _):
            return "/draft_orders/\(id).json"
        case .deleteDraftOrder(let id):
            return "/draft_orders/\(id).json"
        }
    }

    public var method: String {
        switch self {
        case .createDraftOrder:
            return "POST"
        case .getDraftOrder:
            return "GET"
        case .updateDraftOrder:
            return "PUT"
        case .deleteDraftOrder:
            return "DELETE"
        }
    }

    public var headers: [String: String]? {
        let authString = "\(ShopifyConfig.apiKey):\(ShopifyConfig.accessToken)"
        let authData = authString.data(using: .utf8)!
        let base64AuthString = authData.base64EncodedString()
        return [
            "Content-Type": "application/json",
            "Authorization": "Basic \(base64AuthString)"
        ]
    }

    public var queryItems: [URLQueryItem]? {
        return nil
    }

    public var body: Data? {
        switch self {
        case .createDraftOrder(let payload):
            return try? JSONSerialization.data(withJSONObject: payload, options: [])
        case .updateDraftOrder(_, let payload):
            return try? JSONSerialization.data(withJSONObject: payload, options: [])
        case .getDraftOrder, .deleteDraftOrder:
            return nil
        }
    }
}
