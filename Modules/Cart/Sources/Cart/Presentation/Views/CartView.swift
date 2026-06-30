//
//  CartView.swift
//  Cart
//

import SwiftUI

public struct CartView: View {
    @StateObject private var viewModel: CartViewModel

    public init(viewModel: CartViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()

            switch viewModel.state {
            case .idle, .loading:
                loadingView
            case .loaded(let cart):
                cartContent(cart: cart)
            case .empty:
                emptyContent
            case .error(let message):
                errorView(message: message)
            }
        }
        .navigationTitle("My Cart")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: "bag")
                    .foregroundColor(.primary)
            }
        }
        .task {
            await viewModel.loadCart()
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Something went wrong")
        }
    }

    // MARK: - Cart Content

    @ViewBuilder
    private func cartContent(cart: Cart) -> some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 12) {
                    // Header label
                    HStack {
                        Text("Shopping Cart")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 4)

                    // Cart Items
                    ForEach(cart.lines) { item in
                        CartItemRowView(
                            item: item,
                            onRemove: {
                                Task { await viewModel.removeItem(lineID: item.id) }
                            },
                            onIncrement: {
                                Task { await viewModel.incrementItem(lineID: item.id, currentQuantity: item.quantity) }
                            },
                            onDecrement: {
                                Task { await viewModel.decrementItem(lineID: item.id, currentQuantity: item.quantity) }
                            }
                        )
                        .padding(.horizontal, 16)
                    }

                    // Coupon Code
                    CouponCodeView(
                        couponCode: $viewModel.couponCode,
                        isApplying: viewModel.isApplyingCoupon,
                        onApply: {
                            Task { await viewModel.applyCoupon() }
                        }
                    )
                    .padding(.horizontal, 16)

                    // Summary
                    CartSummaryView(
                        totals: cart.totals,
                        discount: viewModel.appliedDiscount
                    )
                    .padding(.horizontal, 16)

                    // Bottom padding so content clears the button
                    Color.clear.frame(height: 100)
                }
                .padding(.vertical, 8)
            }

            // Sticky Checkout Button
            VStack(spacing: 0) {
                Divider()
                Button(action: {
                    viewModel.proceedToCheckout()
                }) {
                    HStack(spacing: 8) {
                        Text("Proceed to Checkout")
                            .font(.system(size: 16, weight: .semibold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color(red: 0.85, green: 0.1, blue: 0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 27))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .background(Color.white)
            }
        }
    }

    // MARK: - Supporting States

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            Text("Loading cart…")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
    }

    private var emptyContent: some View {
        EmptyCartView(onContinueShopping: {
            viewModel.continueShopping()
        })
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            Text(message)
                .font(.system(size: 15))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Button("Try Again") {
                Task { await viewModel.loadCart() }
            }
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(Color(red: 0.85, green: 0.1, blue: 0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
