import Foundation

public enum CartRoute : Hashable{
    case cart
    case checkout(cart: Cart)
    case productDetails(productId: String, handle: String)
    case signInRequired
}
