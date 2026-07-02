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
    
    public init() {}
    
    // MARK: - Lifecycle
    @MainActor
    public func onAppear() async {
        // To be implemented in logic
    }
    
    // MARK: - Actions
    public func increaseTapped(for line: CartLine) async {
        // To be implemented in logic
    }
    
    public func decreaseTapped(for line: CartLine) async {
        // To be implemented in logic
    }
    
    public func requestRemoval(for line: CartLine) {
        pendingRemovalLineId = line.id
    }
    
    public func confirmRemoval() async {
        // To be implemented in logic
        pendingRemovalLineId = nil
    }
    
    public func cancelRemoval() {
        pendingRemovalLineId = nil
    }
    
    public func applyDiscountTapped() async {
        // To be implemented in logic
    }
    
    public func removeDiscountTapped(code: String) async {
        // To be implemented in logic
    }
    
    public func productTapped(line: CartLine) {
        // To be implemented in logic
    }
    
    public func requestClearCart() {
        isShowingClearCartConfirmation = true
    }
    
    public func confirmClearCart() async {
        // To be implemented in logic
        isShowingClearCartConfirmation = false
    }
    
    public func cancelClearCart() {
        isShowingClearCartConfirmation = false
    }
    
    public func requestCheckout() {
        // To be implemented in logic
    }
}
