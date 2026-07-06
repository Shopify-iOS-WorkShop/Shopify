import Foundation

public enum CartRoute{
    case cart
    case checkout(cart: Cart)
    case productDetails(productId: String, handle: String)
    case signInRequired
}
