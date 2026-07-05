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
                    itemsCount: 3,
                    subtotal: "$1,299.00",
                    shippingFee: "$15.00",
                    totalAmount: "$1,314.00"
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
        
        .alert("Payment Successful! 🎉", isPresented: $viewModel.orderSuccess) {
            Button("Awesome", role: .cancel) {
            }
        } message: {
            Text("Your order was successfully placed.")
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
