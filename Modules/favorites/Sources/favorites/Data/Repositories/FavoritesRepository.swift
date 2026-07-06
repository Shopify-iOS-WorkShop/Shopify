import Foundation
import Common

public final class FavoritesRepository: FavoritesRepositoryProtocol {
    private let localDataSource: FavoritesLocalDataSource
    private let sessionProvider: SessionProviding

    public init(localDataSource: FavoritesLocalDataSource, sessionProvider: SessionProviding) {
        self.localDataSource = localDataSource
        self.sessionProvider = sessionProvider
    }

    public func addToFavorites(_ product: FavoriteProduct) -> Result<Void, FavoritesError> {
        guard let userId = sessionProvider.current?.firebaseUID else {
            return .failure(.unauthorized)
        }

        if isFavorite(productId: product.id) {
            return .failure(.alreadyFavorited)
        }

        let item = FavoriteItem(
            id: "\(userId)_\(product.id)",
            userId: userId,
            productId: product.id,
            title: product.title,
            vendor: product.vendor,
            price: product.price,
            rating: product.rating,
            imageURL: product.imageURL?.absoluteString,
            productType: product.productType,
            isInStock: product.isInStock
        )

        do {
            try localDataSource.insert(item)
            return .success(())
        } catch {
            return .failure(.saveFailed(error.localizedDescription))
        }
    }

    public func removeFromFavorites(productId: String) -> Result<Void, FavoritesError> {
        guard let userId = sessionProvider.current?.firebaseUID else {
            return .failure(.unauthorized)
        }

        do {
            try localDataSource.delete(productId: productId, userId: userId)
            return .success(())
        } catch FavoritesLocalDataSourceError.notFound {
            return .failure(.notFound)
        } catch {
            return .failure(.deleteFailed(error.localizedDescription))
        }
    }

    public func fetchFavorites() -> Result<[FavoriteProduct], FavoritesError> {
        guard let userId = sessionProvider.current?.firebaseUID else {
            return .failure(.unauthorized)
        }

        do {
            let items = try localDataSource.fetchAll(userId: userId)
            return .success(items.map(\.asDomain))
        } catch {
            return .failure(.fetchFailed(error.localizedDescription))
        }
    }

    public func isFavorite(productId: String) -> Bool {
        guard let userId = sessionProvider.current?.firebaseUID else {
            return false
        }
        return (try? localDataSource.find(productId: productId, userId: userId)) != nil
    }
}

// MARK: - FavoriteItem → FavoriteProduct mapping

private extension FavoriteItem {
    var asDomain: FavoriteProduct {
        FavoriteProduct(
            id: productId,
            title: title,
            vendor: vendor,
            price: price,
            rating: rating,
            imageURL: imageURL.flatMap(URL.init(string:)),
            productType: productType,
            isInStock: isInStock,
            savedAt: savedAt
        )
    }
}
