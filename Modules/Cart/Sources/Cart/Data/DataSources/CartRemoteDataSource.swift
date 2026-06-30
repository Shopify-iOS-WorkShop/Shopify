//
//  CartRemoteDataSource.swift
//  Cart
//

import Foundation
import ShopifyNetwork

public protocol CartRemoteDataSourceProtocol: Sendable {
    func getDraftOrder(id: String) async throws -> DraftOrderDTO
    func createDraftOrder(customerID: String?) async throws -> DraftOrderDTO
    func updateDraftOrder(id: String, lineItems: [DraftOrderLineItemDTO]) async throws -> DraftOrderDTO
    func deleteDraftOrder(id: String) async throws
}

public struct CartRemoteDataSource: CartRemoteDataSourceProtocol {
    private let networkClient: NetworkClient

    public init(networkClient: NetworkClient = URLSessionNetworkClient()) {
        self.networkClient = networkClient
    }

    public func getDraftOrder(id: String) async throws -> DraftOrderDTO {
        let endpoint = DraftOrderEndpoint.getDraftOrder(id: id)
        let response: DraftOrderResponse = try await networkClient.request(endpoint: endpoint)
        return response.draftOrder
    }

    public func createDraftOrder(customerID: String?) async throws -> DraftOrderDTO {
        var payload: [String: Any] = [:]
        
        var draftOrderDict: [String: Any] = [
            "line_items": [] // Shopify requires at least an empty array or valid items, actually we can create it empty. 
            // Wait, Shopify API requires at least one line item to create a draft order, OR we can just pass an empty array, but sometimes it throws error if empty. Let's pass a dummy item if needed, but let's try empty first.
            // Actually, we can just pass the customer ID.
        ]
        
        if let customerID = customerID, let customerIdInt = Int(customerID) {
            draftOrderDict["customer"] = ["id": customerIdInt]
        }
        
        payload["draft_order"] = draftOrderDict
        
        let endpoint = DraftOrderEndpoint.createDraftOrder(payload: payload)
        let response: DraftOrderResponse = try await networkClient.request(endpoint: endpoint)
        return response.draftOrder
    }

    public func updateDraftOrder(id: String, lineItems: [DraftOrderLineItemDTO]) async throws -> DraftOrderDTO {
        // We need to convert lineItems to a dictionary array for the payload
        let encoder = JSONEncoder()
        let data = try encoder.encode(lineItems)
        let lineItemsArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] ?? []
        
        let payload: [String: Any] = [
            "draft_order": [
                "line_items": lineItemsArray
            ]
        ]
        
        let endpoint = DraftOrderEndpoint.updateDraftOrder(id: id, payload: payload)
        let response: DraftOrderResponse = try await networkClient.request(endpoint: endpoint)
        return response.draftOrder
    }

    public func deleteDraftOrder(id: String) async throws {
        let endpoint = DraftOrderEndpoint.deleteDraftOrder(id: id)
        // For delete, Shopify might return an empty body or just a status code.
        // If the NetworkClient requires a Decodable response and delete returns empty, it will throw decodingFailed.
        // We might need to handle empty response or create an EmptyResponse model in NetworkClient.
        // Assuming NetworkClient can handle it, or we create a dummy Empty struct.
        struct Empty: Decodable {}
        _ = try? await networkClient.request(endpoint: endpoint) as Empty
    }
}
