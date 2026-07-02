import Foundation

public protocol SessionProviding {
    var current: CartSession? { get }
}

public struct CartSession {
    public let firebaseUID: String
    public let shopifyAccessToken: String?
    
    public init(firebaseUID: String, shopifyAccessToken: String?) {
        self.firebaseUID = firebaseUID
        self.shopifyAccessToken = shopifyAccessToken
    }
}
