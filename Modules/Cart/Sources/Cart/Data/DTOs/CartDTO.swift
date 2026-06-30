//
//  CartDTO.swift
//  Cart
//

import Foundation

public struct DraftOrderResponse: Codable {
    public let draftOrder: DraftOrderDTO

    enum CodingKeys: String, CodingKey {
        case draftOrder = "draft_order"
    }
}

public struct DraftOrderDTO: Codable {
    public let id: Int
    public let customer: DraftOrderCustomerDTO?
    public let lineItems: [DraftOrderLineItemDTO]
    public let subtotalPrice: String?
    public let totalPrice: String?
    public let totalTax: String?
    public let currency: String?

    enum CodingKeys: String, CodingKey {
        case id
        case customer
        case lineItems = "line_items"
        case subtotalPrice = "subtotal_price"
        case totalPrice = "total_price"
        case totalTax = "total_tax"
        case currency
    }
}

public struct DraftOrderCustomerDTO: Codable {
    public let id: Int
}

public struct DraftOrderLineItemDTO: Codable {
    public let id: Int?
    public let variantId: Int?
    public let productId: Int?
    public let title: String?
    public let price: String?
    public let quantity: Int
    public let properties: [DraftOrderPropertyDTO]?

    enum CodingKeys: String, CodingKey {
        case id
        case variantId = "variant_id"
        case productId = "product_id"
        case title
        case price
        case quantity
        case properties
    }
}

public struct DraftOrderPropertyDTO: Codable {
    public let name: String
    public let value: String
}
