import Foundation

public enum CartRoute: Hashable {
    case cart
    case checkout
    case productDetails(productId: String, handle: String)
    case signInRequired
}
