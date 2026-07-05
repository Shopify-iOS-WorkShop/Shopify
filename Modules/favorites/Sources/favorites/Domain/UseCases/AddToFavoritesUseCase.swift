import Foundation

public protocol AddToFavoritesUseCaseProtocol {
    func execute(product: FavoriteProduct) -> Result<Void, FavoritesError>
}

public final class AddToFavoritesUseCase: AddToFavoritesUseCaseProtocol {
    private let repository: FavoritesRepositoryProtocol

    public init(repository: FavoritesRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(product: FavoriteProduct) -> Result<Void, FavoritesError> {
        repository.addToFavorites(product)
    }
}
