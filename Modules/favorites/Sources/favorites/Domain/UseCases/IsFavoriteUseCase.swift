import Foundation

public protocol IsFavoriteUseCaseProtocol {
    func execute(productId: String) -> Bool
}

public final class IsFavoriteUseCase: IsFavoriteUseCaseProtocol {
    private let repository: FavoritesRepositoryProtocol

    public init(repository: FavoritesRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(productId: String) -> Bool {
        repository.isFavorite(productId: productId)
    }
}
