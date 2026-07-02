import SwiftUI
import Common

public struct CartView: View {
    @State var viewModel: CartViewModel
    
    public init(viewModel: CartViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.cart == nil {
                    ProgressView("Loading cart...")
                } else if viewModel.isEmpty {
                    EmptyCartView(onShopTapped: {
                        // This usually goes through the coordinator, but here we can just pop
                        // For a real app, we might fire a callback to the coordinator
                    })
                } else {
                    cartContentView
                }
            }
            .navigationTitle("Cart")
            .toolbar {
                if !viewModel.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Clear") {
                            viewModel.requestClearCart()
                        }
                        .foregroundStyle(.red)
                    }
                }
            }
        }
        .task {
            await viewModel.onAppear()
        }
        .confirmationDialog(
            "Clear your entire cart?",
            isPresented: Binding(
                get: { viewModel.isShowingClearCartConfirmation },
                set: { if !$0 { viewModel.cancelClearCart() } }
            ),
            titleVisibility: .visible
        ) {
            Button("Clear Cart", role: .destructive) {
                Task { await viewModel.confirmClearCart() }
            }
            Button("Cancel", role: .cancel) {
                viewModel.cancelClearCart()
            }
        }
        .confirmationDialog(
            "Remove this item from your cart?",
            isPresented: Binding(
                get: { viewModel.pendingRemovalLineId != nil },
                set: { if !$0 { viewModel.cancelRemoval() } }
            ),
            titleVisibility: .visible
        ) {
            Button("Remove", role: .destructive) {
                Task { await viewModel.confirmRemoval() }
            }
            Button("Cancel", role: .cancel) {
                viewModel.cancelRemoval()
            }
        }
    }
    
    private var cartContentView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if let cart = viewModel.cart {
                    ForEach(cart.lines) { line in
                        CartLineItemView(
                            line: line,
                            onIncrease: { Task { await viewModel.increaseTapped(for: line) } },
                            onDecrease: { Task { await viewModel.decreaseTapped(for: line) } },
                            onRemove: { viewModel.requestRemoval(for: line) },
                            onProductTap: { viewModel.productTapped(line: line) }
                        )
                    }
                    
                    CartDiscountView(
                        codes: cart.discountCodes,
                        codeInput: $viewModel.discountCodeInput,
                        isLoading: viewModel.isApplyingDiscount,
                        successMessage: viewModel.successMessage,
                        errorMessage: viewModel.errorMessage,
                        onApply: { Task { await viewModel.applyDiscountTapped() } },
                        onRemove: { code in Task { await viewModel.removeDiscountTapped(code: code) } }
                    )
                    
                    CartSummaryView(
                        cost: cart.cost,
                        onCheckout: {
                            viewModel.requestCheckout()
                        }
                    )
                }
            }
            .padding(.vertical)
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}
