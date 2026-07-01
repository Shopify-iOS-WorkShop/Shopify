import Foundation

public enum AuthProvider: String, Codable, Hashable {
    case emailPassword
    case google
    case apple
}
