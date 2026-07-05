import Foundation
import Combine

@MainActor
public final class ProductDetailViewModel: ObservableObject {

    // MARK: - State

    enum ViewState {
        case idle
        case loading
        case success(ProductDetailEntity)
        case failure(String)
    }

    @Published private(set) var state: ViewState = .idle
    @Published public private(set) var selectedSize: String? = nil
    @Published public private(set) var quantity: Int = 1
    @Published public private(set) var isFavorite: Bool = false
    @Published public private(set) var isDescriptionExpanded: Bool = true
    @Published public private(set) var currentImageIndex: Int = 0

    // MARK: - Dependencies

    private let useCase: FetchProductDetailUseCaseProtocol
    private let productId: Int

    /// Injected from the app layer — checks if a product is already favorited.
    /// Keeps ProductDetails decoupled from the Favorites module.
    public var checkIsFavorite: ((String) -> Bool)?

    /// Injected from the app layer — toggles the favorite state for a product.
    /// Receives: (productId, title, vendor, price, rating, imageURL)
    public var onToggleFavorite: ((String, String, String, Double, Double, String?) -> Void)?

    // MARK: - Init

    public init(productId: Int, useCase: FetchProductDetailUseCaseProtocol) {
        self.productId = productId
        self.useCase = useCase
    }

    // MARK: - Intents

    public func onAppear() {
        Task { await loadProduct() }
    }

    public func selectSize(_ size: String) {
        selectedSize = size
    }

    public func incrementQuantity() {
        quantity += 1
    }

    public func decrementQuantity() {
        guard quantity > 1 else { return }
        quantity -= 1
    }

    public func toggleFavorite() {
        guard case .success(let entity) = state else { return }
        let idStr = String(productId)
        let imageURL = entity.images.first
        onToggleFavorite?(idStr, entity.title, entity.collection, entity.price, entity.rating, imageURL)
        // Re-derive from the source of truth rather than blindly toggling
        isFavorite = checkIsFavorite?(idStr) ?? !isFavorite
    }

    public func toggleDescription() {
        isDescriptionExpanded.toggle()
    }

    public func setImageIndex(_ index: Int) {
        currentImageIndex = index
    }

    public func addToCart() {
        guard selectedSize != nil else { return }
        // Hook into your cart use case here
    }

    // MARK: - Private

    private func loadProduct() async {
        state = .loading
        do {
            let entity = try await useCase.execute(productId: productId)
            selectedSize = entity.sizes.first
            // Prefer the injected live check over the hardcoded mapper value
            isFavorite = checkIsFavorite?(String(productId)) ?? entity.isFavorite
            state = .success(entity)
        } catch {
            state = .failure(error.localizedDescription)
        }
    }
}
