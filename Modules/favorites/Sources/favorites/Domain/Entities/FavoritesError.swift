import Foundation

public enum FavoritesError: LocalizedError, Equatable {
    case unauthorized
    case alreadyFavorited
    case notFound
    case saveFailed(String)
    case fetchFailed(String)
    case deleteFailed(String)

    public var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "You must be logged in to manage favorites."
        case .alreadyFavorited:
            return "This product is already in your favorites."
        case .notFound:
            return "The product was not found in your favorites."
        case .saveFailed(let reason):
            return "Failed to save favorite: \(reason)"
        case .fetchFailed(let reason):
            return "Failed to fetch favorites: \(reason)"
        case .deleteFailed(let reason):
            return "Failed to remove favorite: \(reason)"
        }
    }
}
