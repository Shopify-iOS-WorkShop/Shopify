import Foundation

public enum AppError: Error {
    case network(URLError)
    case graphQL([String])
    case unknown
    
    public var userFacingMessage: String {
        switch self {
        case .network:
            return "Please check your internet connection."
        case .graphQL(let messages):
            return messages.joined(separator: "\n")
        case .unknown:
            return "Something went wrong. Please try again later."
        }
    }
}
