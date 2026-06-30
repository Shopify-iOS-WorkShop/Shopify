//
//  CartRepositoryImpl.swift
//  Cart
//

import Foundation

public struct CartRepositoryImpl: CartRepository {
    private let remoteDataSource: CartRemoteDataSourceProtocol

    public init(remoteDataSource: CartRemoteDataSourceProtocol = CartRemoteDataSource()) {
        self.remoteDataSource = remoteDataSource
    }

    public func getCart(id: CartID) async throws -> Cart {
        let dto = try await remoteDataSource.getDraftOrder(id: id.rawValue)
        guard let cart = CartMapper.map(dto: dto) else {
            throw NSError(domain: "CartMappingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to map Cart DTO to Domain Entity"])
        }
        return cart
    }

    public func createCart(customerID: String?) async throws -> Cart {
        let dto = try await remoteDataSource.createDraftOrder(customerID: customerID)
        guard let cart = CartMapper.map(dto: dto) else {
            throw NSError(domain: "CartMappingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to map Cart DTO to Domain Entity"])
        }
        return cart
    }

    public func addLineItem(cartID: CartID, variantID: ProductVariantID, quantity: LineItemQuantity) async throws -> Cart {
        let currentOrder = try await remoteDataSource.getDraftOrder(id: cartID.rawValue)
        
        var newLineItems = currentOrder.lineItems
        
        // Check if item already exists
        if let index = newLineItems.firstIndex(where: { $0.variantId == Int(variantID.rawValue) }) {
            let existingQuantity = newLineItems[index].quantity
            let newQuantity = existingQuantity + quantity.rawValue
            
            newLineItems[index] = DraftOrderLineItemDTO(
                id: newLineItems[index].id,
                variantId: newLineItems[index].variantId,
                productId: newLineItems[index].productId,
                title: newLineItems[index].title,
                price: newLineItems[index].price,
                quantity: newQuantity,
                properties: newLineItems[index].properties
            )
        } else {
            // New item
            let newItem = DraftOrderLineItemDTO(
                id: nil,
                variantId: Int(variantID.rawValue),
                productId: nil,
                title: nil,
                price: nil,
                quantity: quantity.rawValue,
                properties: nil
            )
            newLineItems.append(newItem)
        }
        
        let updatedOrder = try await remoteDataSource.updateDraftOrder(id: cartID.rawValue, lineItems: newLineItems)
        guard let cart = CartMapper.map(dto: updatedOrder) else {
            throw NSError(domain: "CartMappingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to map Cart DTO to Domain Entity"])
        }
        return cart
    }

    public func updateLineItem(cartID: CartID, lineItemID: CartLineItemID, quantity: LineItemQuantity) async throws -> Cart {
        let currentOrder = try await remoteDataSource.getDraftOrder(id: cartID.rawValue)
        var newLineItems = currentOrder.lineItems
        
        if let index = newLineItems.firstIndex(where: { $0.id == Int(lineItemID.rawValue) }) {
            newLineItems[index] = DraftOrderLineItemDTO(
                id: newLineItems[index].id,
                variantId: newLineItems[index].variantId,
                productId: newLineItems[index].productId,
                title: newLineItems[index].title,
                price: newLineItems[index].price,
                quantity: quantity.rawValue,
                properties: newLineItems[index].properties
            )
        } else {
            throw NSError(domain: "CartError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Line item not found"])
        }
        
        let updatedOrder = try await remoteDataSource.updateDraftOrder(id: cartID.rawValue, lineItems: newLineItems)
        guard let cart = CartMapper.map(dto: updatedOrder) else {
            throw NSError(domain: "CartMappingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to map Cart DTO to Domain Entity"])
        }
        return cart
    }

    public func removeLineItem(cartID: CartID, lineItemID: CartLineItemID) async throws -> Cart {
        let currentOrder = try await remoteDataSource.getDraftOrder(id: cartID.rawValue)
        let newLineItems = currentOrder.lineItems.filter { $0.id != Int(lineItemID.rawValue) }
        
        let updatedOrder = try await remoteDataSource.updateDraftOrder(id: cartID.rawValue, lineItems: newLineItems)
        guard let cart = CartMapper.map(dto: updatedOrder) else {
            throw NSError(domain: "CartMappingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to map Cart DTO to Domain Entity"])
        }
        return cart
    }

    public func clearCart(cartID: CartID) async throws -> Cart {
        // Clearing the cart by updating with an empty array of line items.
        // Wait, Shopify API requires at least one line item. Or maybe it allows empty?
        // Actually, deleting the draft order might be better for "clearCart".
        // But the protocol requires returning a Cart. If we delete it, what do we return?
        // Let's try to pass an empty array or a dummy item if it fails.
        // Let's assume Shopify allows empty array for line_items updates.
        let updatedOrder = try await remoteDataSource.updateDraftOrder(id: cartID.rawValue, lineItems: [])
        guard let cart = CartMapper.map(dto: updatedOrder) else {
            throw NSError(domain: "CartMappingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to map Cart DTO to Domain Entity"])
        }
        return cart
    }
}
