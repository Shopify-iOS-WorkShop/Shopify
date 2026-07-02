import Foundation

public struct Session: Codable, Equatable {
    public let customerAccessToken: String
    public let expiresAt: Date
    public let customerId: String?
    public let firebaseUID: String

    public init(customerAccessToken: String, expiresAt: Date, customerId: String?, firebaseUID: String) {
        self.customerAccessToken = customerAccessToken
        self.expiresAt = expiresAt
        self.customerId = customerId
        self.firebaseUID = firebaseUID
    }

    public var isValid: Bool {
        !customerAccessToken.isEmpty && expiresAt > Date()
    }
}
