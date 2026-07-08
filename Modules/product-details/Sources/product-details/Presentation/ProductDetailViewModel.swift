import Foundation
import Combine

@MainActor
public final class ProductDetailViewModel: ObservableObject {
    public typealias AddToCartAction = (_ variantId: String, _ quantity: Int) async -> String?
    
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
    @Published public private(set) var isAddingToCart: Bool = false
    @Published public private(set) var addToCartMessage: String? = nil
    @Published public private(set) var addToCartError: String? = nil
    @Published public private(set) var isReviewEditorPresented: Bool = false
    @Published public private(set) var editingReview: ReviewEntity? = nil
    @Published public var reviewRating: Int = 5
    @Published public var reviewTitle: String = ""
    @Published public var reviewBody: String = ""
    @Published public private(set) var isReviewSubmitting: Bool = false
    @Published public private(set) var reviewMessage: String? = nil
    @Published public private(set) var reviewError: String? = nil
    @Published public var reviewPendingDeletion: ReviewEntity? = nil
    
    // MARK: - Dependencies
    
    private let useCase: FetchProductDetailUseCaseProtocol
    private let productId: Int
    private let addToCartAction: AddToCartAction?
    
    /// Injected from the app layer — checks if a product is already favorited.
    /// Keeps ProductDetails decoupled from the Favorites module.
    public var checkIsFavorite: ((String) -> Bool)?
    
    /// Injected from the app layer — toggles the favorite state for a product.
    /// Receives: (productId, title, vendor, price, rating, imageURL)
    public var onToggleFavorite: ((String, String, String, Double, Double, String?) -> Void)?
    
    // MARK: - Init
    
    public init(
        productId: Int,
        useCase: FetchProductDetailUseCaseProtocol,
        addToCartAction: AddToCartAction? = nil
    ) {
        
        self.productId = productId
        self.useCase = useCase
        self.addToCartAction = addToCartAction
        
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
        
        guard case .success(let product) = state,
              let variantId = product.variantId(for: selectedSize),
              let addToCartAction else { return }
        
        isAddingToCart = true
        addToCartMessage = nil
        addToCartError = nil
        
        Task { @MainActor in
            if let error = await addToCartAction(variantId, quantity) {
                addToCartError = error
            }
            isAddingToCart = false
        }
    }

    public func beginCreateReview() {
        guard currentProduct != nil else { return }
        editingReview = currentCustomerReview
        reviewRating = Int(editingReview?.rating ?? 5)
        reviewTitle = editingReview?.title ?? ""
        reviewBody = editingReview?.body ?? ""
        reviewMessage = nil
        reviewError = nil
        isReviewEditorPresented = true
    }

    public func beginEditReview(_ review: ReviewEntity) {
        guard review.isOwnedByCurrentCustomer else { return }
        editingReview = review
        reviewRating = Int(review.rating)
        reviewTitle = review.title ?? ""
        reviewBody = review.body
        reviewMessage = nil
        reviewError = nil
        isReviewEditorPresented = true
    }

    public func dismissReviewEditor() {
        guard !isReviewSubmitting else { return }
        isReviewEditorPresented = false
    }

    public func requestDeleteReview(_ review: ReviewEntity) {
        guard review.isOwnedByCurrentCustomer else { return }
        reviewPendingDeletion = review
    }

    public func cancelDeleteReview() {
        reviewPendingDeletion = nil
    }

    public func confirmDeleteReview() {
        guard let review = reviewPendingDeletion else { return }
        reviewPendingDeletion = nil
        Task { @MainActor in
            await deleteReview(review)
        }
    }

    public func submitReview() {
        guard let product = currentProduct else { return }

        let title = reviewTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let body = reviewBody.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty, !body.isEmpty else {
            reviewError = "Add a title and a few words about your experience."
            return
        }

        let input = ReviewInput(
            rating: max(1, min(5, reviewRating)),
            title: title,
            body: body
        )

        isReviewSubmitting = true
        reviewError = nil
        reviewMessage = nil

        Task { @MainActor in
            do {
                let updatedProduct: ProductDetailEntity
                if let editingReview {
                    updatedProduct = try await useCase.updateReview(productId: product.id, review: editingReview, input: input)
                    reviewMessage = "Review updated."
                } else {
                    updatedProduct = try await useCase.createReview(productId: product.id, input: input)
                    reviewMessage = "Review added."
                }
                state = .success(updatedProduct)
                isReviewEditorPresented = false
                self.editingReview = nil
            } catch {
                reviewError = error.localizedDescription
            }
            isReviewSubmitting = false
        }
    }
    // MARK: - Private
    private var currentProduct: ProductDetailEntity? {
        guard case .success(let product) = state else { return nil }
        return product
    }

    private var currentCustomerReview: ReviewEntity? {
        currentProduct?.reviews.first(where: \.isOwnedByCurrentCustomer)
    }

    private func deleteReview(_ review: ReviewEntity) async {
        guard let product = currentProduct else { return }
        isReviewSubmitting = true
        reviewError = nil
        reviewMessage = nil
        do {
            let updatedProduct = try await useCase.deleteReview(productId: product.id, review: review)
            state = .success(updatedProduct)
            reviewMessage = "Review deleted."
        } catch {
            reviewError = error.localizedDescription
        }
        isReviewSubmitting = false
    }

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
