//
//  File.swift
//  
//
//  Created by Mazen Amr on 07/07/2026.
//

import Foundation

public struct FullOrder: Equatable, Identifiable {
    public let id: String
    public let orderNumber: Int
    public let processedAt: Date
    public let financialStatus: String
    public let totalAmount: Double
    public let subtotalAmount: Double
    public let shippingFee: Double
    public let currencyCode: String
    public let shippingAddress: OrderAddress?
    public let lineItems: [OrderLineItem]
    
    public init(id: String, orderNumber: Int, processedAt: Date, financialStatus: String, totalAmount: Double, subtotalAmount: Double, shippingFee: Double, currencyCode: String, shippingAddress: OrderAddress?, lineItems: [OrderLineItem]) {
        self.id = id
        self.orderNumber = orderNumber
        self.processedAt = processedAt
        self.financialStatus = financialStatus
        self.totalAmount = totalAmount
        self.subtotalAmount = subtotalAmount
        self.shippingFee = shippingFee
        self.currencyCode = currencyCode
        self.shippingAddress = shippingAddress
        self.lineItems = lineItems
    }
}
