import SwiftUI
import Observation
import Common

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
    
    public var originalSubtotal: Decimal {
        cart?.lines.reduce(Decimal(0)) { $0 + ($1.price.amount * Decimal($1.quantity)) } ?? Decimal(0)
    }
    
    public var productDiscountAmount: Decimal {
        let total = cart?.cost.totalAmount.amount ?? Decimal(0)
        let original = originalSubtotal
        return original > total ? original - total : Decimal(0)
    }
    
    // MARK: - Dependencies
    private let getOrCreateCartUseCase: GetOrCreateCartUseCase
    private let addCartLineUseCase: AddCartLineUseCase
    private let updateQuantityUseCase: UpdateCartLineQuantityUseCase
    private let removeLineUseCase: RemoveCartLineUseCase
    private let applyDiscountUseCase: ApplyDiscountCodeUseCase
    private let removeDiscountUseCase: RemoveDiscountCodeUseCase
    private let observeCartUseCase: ObserveCartUseCase
    private let clearCartUseCase: ClearCartUseCase
    private let sessionStore: SessionProviding
    
    public init(
        getOrCreateCartUseCase: GetOrCreateCartUseCase,
        addCartLineUseCase: AddCartLineUseCase,
        updateQuantityUseCase: UpdateCartLineQuantityUseCase,
        removeLineUseCase: RemoveCartLineUseCase,
        applyDiscountUseCase: ApplyDiscountCodeUseCase,
        removeDiscountUseCase: RemoveDiscountCodeUseCase,
        observeCartUseCase: ObserveCartUseCase,
        clearCartUseCase: ClearCartUseCase,
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
    
    // MARK: - Lifecycle
    @MainActor
    public func onAppear() async {
        isLoading = true
        
        // MARK: - Simulator Network Bug Workaround
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        errorMessage = nil
        successMessage = nil
        
        let result = await getOrCreateCartUseCase.execute()
        switch result {
        case .success(let fetchedCart):
            self.cart = fetchedCart
        case .failure(let error):
            self.errorMessage = error.userFacingMessage
        }
        
        isLoading = false
        
        // Start observing cart changes
        Task {
            for await updatedCart in observeCartUseCase.execute() {
                await MainActor.run {
                    self.cart = updatedCart
                    if let cartId = updatedCart?.id {
                        print("🛒 [CartViewModel] Current Cart ID: \(cartId)")
                    }
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
        if case .failure(let error) = result {
            errorMessage = error.userFacingMessage
        }
    }
    
    @MainActor
    public func decreaseTapped(for line: CartLine) async {
        if line.quantity == 1 {
            requestRemoval(for: line)
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
        if case .failure(let error) = result {
            errorMessage = error.userFacingMessage
        }
    }
    
    public func requestRemoval(for line: CartLine) {
        pendingRemovalLineId = line.id
    }
    
    @MainActor
    public func confirmRemoval(lineId: String) async {
        pendingRemovalLineId = nil
        
        isLoading = true
        errorMessage = nil
        
        let result = await removeLineUseCase.execute(lineId: lineId)
        
        isLoading = false
        if case .failure(let error) = result {
            errorMessage = error.userFacingMessage
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
        case .success(let updatedCart):
            // Check if the code was marked as applicable
            if let appliedCode = updatedCart.discountCodes.first(where: { $0.code == code }), !appliedCode.applicable {
                errorMessage = "Discount code '\(code)' is invalid or not applicable."
                // Remove the inapplicable code so it doesn't stay stuck on the cart
                Task { await removeDiscountUseCase.execute(code: code) }
            } else {
                successMessage = "Discount '\(code)' applied!"
                discountCodeInput = ""
            }
        case .failure(let error):
            errorMessage = error.userFacingMessage
        }
    }
    
    @MainActor
    public func removeDiscountTapped(code: String) async {
        isLoading = true
        errorMessage = nil
        
        let result = await removeDiscountUseCase.execute(code: code)
        
        isLoading = false
        if case .failure(let error) = result {
            errorMessage = error.userFacingMessage
        }
    }
    
    public func productTapped(line: CartLine) {
        // Navigate to product details - handled by coordinator
    }
    
    public var cartItemCount: Int {
        cart?.lines.count ?? 0
    }
    
    @MainActor
    public func addLine(variantId: String, quantity: Int) async -> String? {
        let result = await addCartLineUseCase.execute(variantId: variantId, quantity: quantity)
        switch result {
        case .success(let updatedCart):
            self.cart = updatedCart
            return nil
        case .failure(let error):
            return error.userFacingMessage
        }
    }
    
    public func requestClearCart() {
        isShowingClearCartConfirmation = true
    }
    
    @MainActor
    public func confirmClearCart() async {
        isShowingClearCartConfirmation = false
        await clearCartUseCase.execute()
        cart = nil
    }
    
    public func cancelClearCart() {
        isShowingClearCartConfirmation = false
    }
    
    public func requestCheckout() {
        guard sessionStore.current != nil else {
            // Not authenticated - show sign in
            return
        }
        // Navigate to checkout - handled by coordinator
    }
}
