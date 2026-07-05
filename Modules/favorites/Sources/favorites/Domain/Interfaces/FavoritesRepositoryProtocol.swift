import Foundation

public protocol FavoritesRepositoryProtocol {
    func addToFavorites(_ product: FavoriteProduct) -> Result<Void, FavoritesError>
    func removeFromFavorites(productId: String) -> Result<Void, FavoritesError>
    func fetchFavorites() -> Result<[FavoriteProduct], FavoritesError>
    func isFavorite(productId: String) -> Bool
}
