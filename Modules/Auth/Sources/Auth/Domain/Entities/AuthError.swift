import Foundation

public enum AuthError: LocalizedError, Equatable {
    case validation(String)
    case authentication(String)
    case shopify(String)
    case missingSession
    case unknown(String)

    public var errorDescription: String? {
        switch self {
        case .validation(let message),
             .authentication(let message),
             .shopify(let message),
             .unknown(let message):
            return message
        case .missingSession:
            return "Please sign in again to continue."
        }
    }

    public var userFacingMessage: String {
        errorDescription ?? "An unexpected error occurred."
    }
}
