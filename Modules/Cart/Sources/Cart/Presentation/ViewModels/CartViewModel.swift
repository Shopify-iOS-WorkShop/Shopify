import SwiftUI
import Observation

@Observable
public final class CartViewModel {
    
    // MARK: - State
    public private(set) var cart: Cart? = nil
    public private(set) var isLoading: Bool = false
    public private(set) var errorMessage: String? = nil
    public private(set) var successMessage: String? = nil
    public var discountCodeInput: String = ""
    public private(set) var isApplyingDiscount: Bool = false
    
    public private(set) var pendingRemovalLineId: String? = nil
    public var isShowingClearCartConfirmation: Bool = false
    
    public var isEmpty: Bool {
        return cart?.lines.isEmpty ?? true
    }
    
    // Navigation closures (set by CartCoordinator)
    public var onCheckoutTapped: ((URL?) -> Void)?
    public var onSignInRequired: (() -> Void)?
    public var onProductTapped: ((String, String) -> Void)?
    
    // MARK: - Dependencies
    private let getOrCreateCartUseCase: GetOrCreateCartUseCaseProtocol
    private let addCartLineUseCase: AddCartLineUseCaseProtocol
    private let updateQuantityUseCase: UpdateCartLineQuantityUseCaseProtocol
    private let removeLineUseCase: RemoveCartLineUseCaseProtocol
    private let applyDiscountUseCase: ApplyDiscountCodeUseCaseProtocol
    private let removeDiscountUseCase: RemoveDiscountCodeUseCaseProtocol
    private let observeCartUseCase: ObserveCartUseCaseProtocol
    private let clearCartUseCase: ClearCartUseCaseProtocol
    private let sessionStore: SessionProviding
    
    public init(
        getOrCreateCartUseCase: GetOrCreateCartUseCaseProtocol,
        addCartLineUseCase: AddCartLineUseCaseProtocol,
        updateQuantityUseCase: UpdateCartLineQuantityUseCaseProtocol,
        removeLineUseCase: RemoveCartLineUseCaseProtocol,
        applyDiscountUseCase: ApplyDiscountCodeUseCaseProtocol,
        removeDiscountUseCase: RemoveDiscountCodeUseCaseProtocol,
        observeCartUseCase: ObserveCartUseCaseProtocol,
        clearCartUseCase: ClearCartUseCaseProtocol,
        sessionStore: SessionProviding
    ) {
        self.getOrCreateCartUseCase = getOrCreateCartUseCase
        self.addCartLineUseCase = addCartLineUseCase
        self.updateQuantityUseCase = updateQuantityUseCase
        self.removeLineUseCase = removeLineUseCase
        self.applyDiscountUseCase = applyDiscountUseCase
        self.removeDiscountUseCase = removeDiscountUseCase
        self.observeCartUseCase = observeCartUseCase
        self.clearCartUseCase = clearCartUseCase
        self.sessionStore = sessionStore
    }
    
    // MARK: - Computed for View
    public var isAuthenticated: Bool {
        return sessionStore.current != nil
    }
    
    // MARK: - Lifecycle
    @MainActor
    public func onAppear() async {
        isLoading = true
        let result = await getOrCreateCartUseCase.execute()
        isLoading = false
        if case .failure(let error) = result {
            errorMessage = error.userFacingMessage
        }
        startObserving()
    }
    
    private func startObserving() {
        Task {
            for await updatedCart in observeCartUseCase.execute() {
                await MainActor.run {
                    self.cart = updatedCart
                }
            }
        }
    }
    
    // MARK: - Actions
    @MainActor
    public func increaseTapped(for line: CartLine) async {
        isLoading = true
        errorMessage = nil
        let result = await updateQuantityUseCase.execute(
            lineId: line.id,
            newQuantity: line.quantity + 1,
            quantityAvailable: line.quantityAvailable
        )
        isLoading = false
        if case .failure(let e) = result {
            errorMessage = e.userFacingMessage
        }
    }
    
    @MainActor
    public func decreaseTapped(for line: CartLine) async {
        if line.quantity == 1 {
            pendingRemovalLineId = line.id
            return
        }
        isLoading = true
        errorMessage = nil
        let result = await updateQuantityUseCase.execute(
            lineId: line.id,
            newQuantity: line.quantity - 1,
            quantityAvailable: line.quantityAvailable
        )
        isLoading = false
        if case .failure(let e) = result {
            errorMessage = e.userFacingMessage
        }
    }
    
    public func requestRemoval(for line: CartLine) {
        pendingRemovalLineId = line.id
    }
    
    @MainActor
    public func confirmRemoval() async {
        guard let lineId = pendingRemovalLineId else { return }
        pendingRemovalLineId = nil
        isLoading = true
        errorMessage = nil
        let result = await removeLineUseCase.execute(lineId: lineId)
        isLoading = false
        if case .failure(let e) = result {
            errorMessage = e.userFacingMessage
        }
    }
    
    public func cancelRemoval() {
        pendingRemovalLineId = nil
    }
    
    @MainActor
    public func applyDiscountTapped() async {
        let code = discountCodeInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !code.isEmpty else { return }
        
        isApplyingDiscount = true
        errorMessage = nil
        successMessage = nil
        
        let result = await applyDiscountUseCase.execute(code: code)
        isApplyingDiscount = false
        
        switch result {
        case .success:
            successMessage = "Discount '\(code)' applied!"
            discountCodeInput = ""
        case .failure(let e):
            errorMessage = e.userFacingMessage
        }
    }
    
    @MainActor
    public func removeDiscountTapped(code: String) async {
        isApplyingDiscount = true
        errorMessage = nil
        successMessage = nil
        let result = await removeDiscountUseCase.execute(codeToRemove: code)
        isApplyingDiscount = false
        if case .failure(let e) = result {
            errorMessage = e.userFacingMessage
        }
    }
    
    public func productTapped(line: CartLine) {
        onProductTapped?(line.productId, line.productHandle)
    }
    
    public func requestClearCart() {
        isShowingClearCartConfirmation = true
    }
    
    @MainActor
    public func confirmClearCart() async {
        isShowingClearCartConfirmation = false
        await clearCartUseCase.execute()
    }
    
    public func cancelClearCart() {
        isShowingClearCartConfirmation = false
    }
    
    public func requestCheckout() {
        guard isAuthenticated else {
            onSignInRequired?()
            return
        }
        onCheckoutTapped?(cart?.checkoutUrl)
    }
}
