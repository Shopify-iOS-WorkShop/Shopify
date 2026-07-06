//
//  File.swift
//  
//
//  Created by Mazen Amr on 04/07/2026.
//
import Foundation
import SwiftUI
import Common

public struct PaymentMethodView: View {
    @StateObject private var viewModel: PaymentMethodViewModel
    @Environment(CheckoutAddressCoordinator.self) private var coordinator
    public init(viewModel: PaymentMethodViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                CheckoutStepper(currentStep: .payment)
                    .padding(.top, 20)
                
                Text("Payment Method")
                    .font(.system(size: 20, weight: .bold))
                
                HStack(spacing: 12) {
                    PaymentMethodButton(title: "Online Payment", icon: "creditcard", type: .online, selectedMethod: $viewModel.selectedMethod)
                    PaymentMethodButton(title: "Cash on Delivery", icon: "banknote", type: .cod, selectedMethod: $viewModel.selectedMethod)
                }
                
                if viewModel.selectedMethod == .online {
                    VStack(spacing: 16) {
                        CardInputField(title: "CARD NUMBER", placeholder: "0000 0000 0000 0000", text: $viewModel.cardNumber, icon: "creditcard")
                        
                        HStack(spacing: 16) {
                            CardInputField(title: "EXPIRY (MM/YY)", placeholder: "12/26", text: $viewModel.expiry)
                            CardInputField(title: "CVV", placeholder: "***", text: $viewModel.cvv)
                        }
                    }
                }
                
                OrderSummaryBox(
                    itemsCount: viewModel.totalItems,
                    subtotal: viewModel.subtotalFormatted,
                    shippingFee: viewModel.deliveryFeeFormatted,
                    totalAmount: viewModel.totalFormatted
                )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            CheckoutBottomButton(title: viewModel.isLoading ? "Processing..." : "Place Order") {
                Task {
                    await viewModel.processPayment()
                }
            }
            .disabled(viewModel.isLoading)
        }
        .onTapGesture { UIApplication.shared.endEditing() }
        
        .onChange(of: viewModel.orderSuccess) { oldValue, isSuccess in
            if isSuccess {
                coordinator.push(.success)
            }
        }
        .alert("Payment Failed", isPresented: Binding<Bool>(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }
}
