//
//  CustomerOrder.swift
//  Settings — Domain
//

import Foundation

public struct CustomerOrder: Equatable, Identifiable,Hashable {
    public let id: String
    public let orderNumber: Int
    public let processedAt: Date
    public let financialStatus: String
    public let fulfillmentStatus: String?
    public let totalAmount: String
    public let currencyCode: String
    public let firstItemTitle: String?
    public let firstItemImageURL: URL?

    public init(
        id: String,
        orderNumber: Int,
        processedAt: Date,
        financialStatus: String,
        fulfillmentStatus: String?,
        totalAmount: String,
        currencyCode: String,
        firstItemTitle: String?,
        firstItemImageURL: URL?
    ) {
        self.id = id
        self.orderNumber = orderNumber
        self.processedAt = processedAt
        self.financialStatus = financialStatus
        self.fulfillmentStatus = fulfillmentStatus
        self.totalAmount = totalAmount
        self.currencyCode = currencyCode
        self.firstItemTitle = firstItemTitle
        self.firstItemImageURL = firstItemImageURL
    }
}
