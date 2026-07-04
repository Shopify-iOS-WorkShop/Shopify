//
//  CustomerProfileDTO.swift
//  Settings — Data
//

import Foundation

// MARK: - GraphQL Response Wrappers

struct SettingsGraphQLResponse<T: Decodable>: Decodable {
    let data: T?
    let errors: [SettingsGraphQLError]?
}

struct SettingsGraphQLError: Decodable {
    let message: String
}

// MARK: - Customer Query Response

struct CustomerQueryContainer: Decodable {
    let customer: CustomerDTO?
}

struct CustomerDTO: Decodable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let phone: String?
    let defaultAddress: AddressDTO?
    let orders: OrderConnectionDTO
}

struct AddressDTO: Decodable {
    let id: String
    let firstName: String
    let lastName: String
    let address1: String
    let city: String
    let country: String
    let phone: String?
}

struct OrderConnectionDTO: Decodable {
    let edges: [OrderEdgeDTO]
}

struct OrderEdgeDTO: Decodable {
    let node: OrderNodeDTO
}

struct OrderNodeDTO: Decodable {
    let id: String
    let orderNumber: Int
    let processedAt: String
    let financialStatus: String
    let fulfillmentStatus: String?
    let currentTotalPrice: MoneyDTO
    let lineItems: LineItemConnectionDTO
}

struct MoneyDTO: Decodable {
    let amount: String
    let currencyCode: String
}

struct LineItemConnectionDTO: Decodable {
    let edges: [LineItemEdgeDTO]
}

struct LineItemEdgeDTO: Decodable {
    let node: LineItemNodeDTO
}

struct LineItemNodeDTO: Decodable {
    let title: String
    let quantity: Int
    let variant: LineItemVariantDTO?
}

struct LineItemVariantDTO: Decodable {
    let image: LineItemImageDTO?
}

struct LineItemImageDTO: Decodable {
    let url: String
}

// MARK: - Mapper

extension CustomerDTO {
    func toDomain() -> CustomerProfile {
        let orders = self.orders.edges.map { edge -> CustomerOrder in
            let node = edge.node
            let date = ISO8601DateFormatter().date(from: node.processedAt) ?? Date()
            let firstItem = node.lineItems.edges.first?.node
            let imageURL = firstItem?.variant?.image?.url.flatMap { URL(string: $0) }
            return CustomerOrder(
                id: node.id,
                orderNumber: node.orderNumber,
                processedAt: date,
                financialStatus: node.financialStatus,
                fulfillmentStatus: node.fulfillmentStatus,
                totalAmount: node.currentTotalPrice.amount,
                currencyCode: node.currentTotalPrice.currencyCode,
                firstItemTitle: firstItem?.title,
                firstItemImageURL: imageURL
            )
        }

        let address = defaultAddress.map { a in
            CustomerAddress(
                id: a.id,
                firstName: a.firstName,
                lastName: a.lastName,
                address1: a.address1,
                city: a.city,
                country: a.country,
                phone: a.phone
            )
        }

        return CustomerProfile(
            id: id,
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone,
            defaultAddress: address,
            recentOrders: orders
        )
    }
}
