//
//  File.swift
//  
//
//  Created by Mazen Amr on 07/07/2026.
//

import Foundation
import ShopifyNetwork
import Auth

public final class OrderDetailsRepository: OrderDetailsRepositoryProtocol {
    private let client: GraphQLClientProtocol
    private let authRepository: AuthRepositoryProtocol

    public init(
        client: GraphQLClientProtocol = GraphQLClient.shared,
        authRepository: AuthRepositoryProtocol
    ) {
        self.client = client
        self.authRepository = authRepository
    }

    private func getCustomerToken() throws -> String {
        guard let session = authRepository.currentSession() else {
            throw OrderDetailsError.missingToken
        }
        return session.customerAccessToken
    }

    public func fetchOrderDetails(orderId: String, customerAccessToken: String) async throws -> FullOrder {
        let token = try getCustomerToken()
        let query = ShopifyAPI.GetOrderDetailsQuery(
            customerAccessToken: token
        )

        let data = try await client.fetch(query: query)

        guard let node = data.customer?.orders.edges.first?.node else {
            throw OrderDetailsError.notFound
        }

        return mapToDomain(node: node)
    }

    private func mapToDomain(node: ShopifyAPI.GetOrderDetailsQuery.Data.Customer.Orders.Edge.Node) -> FullOrder {
        let dateFormatter = ISO8601DateFormatter()
        let processedDate = dateFormatter.date(from: node.processedAt) ?? Date()

        var domainAddress: OrderAddress? = nil
        if let addr = node.shippingAddress {
            domainAddress = OrderAddress(
                firstName: addr.firstName ?? "",
                lastName: addr.lastName ?? "",
                address1: addr.address1 ?? "",
                city: addr.city ?? "",
                country: addr.country ?? "",
                phone: addr.phone ?? ""
            )
        }

        let domainItems: [OrderLineItem] = node.lineItems.edges.map { edge in
            let item = edge.node

            let variant = item.variant

            let price = Double(variant?.price.amount ?? "") ?? 0

            let imageURL: URL?
            if let url = variant?.image?.url {
                imageURL = URL(string: url)
            } else {
                imageURL = nil
            }

            return OrderLineItem(
                id: UUID().uuidString,
                title: item.title,
                variantTitle: variant?.title,
                quantity: item.quantity,
                price: price,
                imageURL: imageURL
            )
        }

        let totalAmount = Double(node.totalPrice.amount) ?? 0.0
        let subtotalAmount = node.subtotalPrice.flatMap { Double($0.amount) } ?? 0.0
        
        return FullOrder(
            id: node.id,
            orderNumber: node.orderNumber,
            processedAt: processedDate,
            financialStatus: node.financialStatus?.rawValue ?? "PENDING",
            totalAmount: totalAmount,
            subtotalAmount: subtotalAmount,
            shippingFee: max(totalAmount - subtotalAmount, 0.0),
            currencyCode: node.totalPrice.currencyCode.rawValue,
            shippingAddress: domainAddress,
            lineItems: domainItems
        )
    }
}

public enum OrderDetailsError: Error, LocalizedError {
    case notFound
    case missingToken

    public var errorDescription: String? {
        switch self {
        case .notFound: return "Order not found."
        case .missingToken: return "You must be signed in to view order details."
        }
    }
}

