import Foundation
import SwiftData

@Model
public final class CartRecord {
    @Attribute(.unique) public var ownerKey: String
    
    public var cartId: String
    public var cartIdCreatedAt: Date
    public var lastKnownCheckoutUrl: String?
    public var totalQuantity: Int
    public var updatedAt: Date
    
    public init(
        ownerKey: String,
        cartId: String,
        cartIdCreatedAt: Date = Date(),
        lastKnownCheckoutUrl: String? = nil,
        totalQuantity: Int = 0,
        updatedAt: Date = Date()
    ) {
        self.ownerKey = ownerKey
        self.cartId = cartId
        self.cartIdCreatedAt = cartIdCreatedAt
        self.lastKnownCheckoutUrl = lastKnownCheckoutUrl
        self.totalQuantity = totalQuantity
        self.updatedAt = updatedAt
    }
}
