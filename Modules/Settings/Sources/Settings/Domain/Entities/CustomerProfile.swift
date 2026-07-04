//
//  CustomerProfile.swift
//  Settings — Domain
//

import Foundation

public struct CustomerProfile: Equatable {
    public let id: String
    public let firstName: String
    public let lastName: String
    public let email: String
    public let phone: String?
    public let defaultAddress: CustomerAddress?
    public let recentOrders: [CustomerOrder]

    public var fullName: String { "\(firstName) \(lastName)" }

    public init(
        id: String,
        firstName: String,
        lastName: String,
        email: String,
        phone: String?,
        defaultAddress: CustomerAddress?,
        recentOrders: [CustomerOrder]
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.defaultAddress = defaultAddress
        self.recentOrders = recentOrders
    }
}

public struct CustomerAddress: Equatable {
    public let id: String
    public let firstName: String
    public let lastName: String
    public let address1: String
    public let city: String
    public let country: String
    public let phone: String?

    public var singleLine: String { "\(address1), \(city), \(country)" }

    public init(
        id: String,
        firstName: String,
        lastName: String,
        address1: String,
        city: String,
        country: String,
        phone: String?
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.address1 = address1
        self.city = city
        self.country = country
        self.phone = phone
    }
}
