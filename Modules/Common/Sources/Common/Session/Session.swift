//
//  Session.swift
//  Common
//
//  Session entity for authentication state
//

import Foundation

public struct Session: Equatable, Sendable {
    public let firebaseUID: String
    public let customerAccessToken: String
    public let customerId: String?
    public let expiresAt: Date
    
    public init(
        firebaseUID: String,
        customerAccessToken: String,
        customerId: String?,
        expiresAt: Date
    ) {
        self.firebaseUID = firebaseUID
        self.customerAccessToken = customerAccessToken
        self.customerId = customerId
        self.expiresAt = expiresAt
    }
    
    public var isExpired: Bool {
        Date() > expiresAt
    }
}
