import Foundation

public protocol RemoveFromFavoritesUseCaseProtocol {
    func execute(productId: String) -> Result<Void, FavoritesError>
}

public final class RemoveFromFavoritesUseCase: RemoveFromFavoritesUseCaseProtocol {
    private let repository: FavoritesRepositoryProtocol

    public init(repository: FavoritesRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(productId: String) -> Result<Void, FavoritesError> {
        repository.removeFromFavorites(productId: productId)
    }
}
