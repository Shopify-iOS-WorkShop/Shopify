import Foundation

public protocol FetchFavoritesUseCaseProtocol {
    func execute() -> Result<[FavoriteProduct], FavoritesError>
}

public final class FetchFavoritesUseCase: FetchFavoritesUseCaseProtocol {
    private let repository: FavoritesRepositoryProtocol

    public init(repository: FavoritesRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() -> Result<[FavoriteProduct], FavoritesError> {
        repository.fetchFavorites()
    }
}
