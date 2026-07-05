import Foundation
import Combine

@MainActor
public final class FavoritesViewModel: ObservableObject {

    // MARK: - State

    public enum ViewState {
        case idle
        case loading
        case empty
        case loaded([FavoriteProduct])
        case failure(String)
    }

    @Published public private(set) var state: ViewState = .idle
    @Published public private(set) var favoritedIDs: Set<String> = []

    // MARK: - Dependencies

    private let fetchFavoritesUseCase: FetchFavoritesUseCaseProtocol
    private let addToFavoritesUseCase: AddToFavoritesUseCaseProtocol
    private let removeFromFavoritesUseCase: RemoveFromFavoritesUseCaseProtocol
    private let isFavoriteUseCase: IsFavoriteUseCaseProtocol

    // MARK: - Init

    public init(
        fetchFavoritesUseCase: FetchFavoritesUseCaseProtocol,
        addToFavoritesUseCase: AddToFavoritesUseCaseProtocol,
        removeFromFavoritesUseCase: RemoveFromFavoritesUseCaseProtocol,
        isFavoriteUseCase: IsFavoriteUseCaseProtocol
    ) {
        self.fetchFavoritesUseCase = fetchFavoritesUseCase
        self.addToFavoritesUseCase = addToFavoritesUseCase
        self.removeFromFavoritesUseCase = removeFromFavoritesUseCase
        self.isFavoriteUseCase = isFavoriteUseCase
    }

    // MARK: - Intents

    public func onAppear() {
        loadFavorites()
    }

    public func loadFavorites() {
        switch fetchFavoritesUseCase.execute() {
        case .success(let products):
            favoritedIDs = Set(products.map(\.id))
            state = products.isEmpty ? .empty : .loaded(products)
        case .failure(let error):
            state = .failure(error.localizedDescription ?? "Failed to load favorites.")
        }
    }

    public func remove(productId: String) {
        switch removeFromFavoritesUseCase.execute(productId: productId) {
        case .success:
            loadFavorites()
        case .failure(let error):
            state = .failure(error.localizedDescription ?? "Failed to remove item.")
        }
    }

    public func add(product: FavoriteProduct) {
        switch addToFavoritesUseCase.execute(product: product) {
        case .success:
            loadFavorites()
        case .failure(let error):
            if case .alreadyFavorited = error { return }
            state = .failure(error.localizedDescription ?? "Failed to add item.")
        }
    }

    public func isFavorite(productId: String) -> Bool {
        favoritedIDs.contains(productId)
    }

    public func toggleFavorite(product: FavoriteProduct) {
        if isFavorite(productId: product.id) {
            remove(productId: product.id)
        } else {
            add(product: product)
        }
    }
}
