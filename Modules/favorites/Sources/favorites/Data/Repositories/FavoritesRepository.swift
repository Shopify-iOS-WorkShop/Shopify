import Foundation

public final class FavoritesRepository: FavoritesRepositoryProtocol {
    private let localDataSource: FavoritesLocalDataSource

    public init(localDataSource: FavoritesLocalDataSource) {
        self.localDataSource = localDataSource
    }

    public func addToFavorites(_ product: FavoriteProduct) -> Result<Void, FavoritesError> {
        if isFavorite(productId: product.id) {
            return .failure(.alreadyFavorited)
        }

        let item = FavoriteItem(
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
        do {
            try localDataSource.delete(productId: productId)
            return .success(())
        } catch FavoritesLocalDataSourceError.notFound {
            return .failure(.notFound)
        } catch {
            return .failure(.deleteFailed(error.localizedDescription))
        }
    }

    public func fetchFavorites() -> Result<[FavoriteProduct], FavoritesError> {
        do {
            let items = try localDataSource.fetchAll()
            return .success(items.map(\.asDomain))
        } catch {
            return .failure(.fetchFailed(error.localizedDescription))
        }
    }

    public func isFavorite(productId: String) -> Bool {
        (try? localDataSource.find(productId: productId)) != nil
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
