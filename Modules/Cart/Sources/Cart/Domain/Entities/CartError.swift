import Foundation

public enum CartError: LocalizedError, Equatable, Sendable {
    case unauthenticated
    case emptyCart
    case invalidQuantity
    case insufficientStock(available: Int)
    case missingCart
    case networkFailure
    case unknown(message: String)

    public var errorDescription: String? {
        switch self {
        case .unauthenticated:
            return "Please sign in to use your cart."
        case .emptyCart:
            return "Your cart is empty."
        case .invalidQuantity:
            return "Please choose a valid quantity."
        case .insufficientStock(let available):
            return "Only \(available) item(s) are available."
        case .missingCart:
            return "Cart was not found."
        case .networkFailure:
            return "Unable to update cart. Please try again."
        case .unknown(let message):
            return message
        }
    }
}
