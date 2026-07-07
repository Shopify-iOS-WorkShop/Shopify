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
                            .onChange(of: viewModel.cardNumber) { _, newValue in
                                let numbers = newValue.filter { $0.isNumber }
                                let limited = String(numbers.prefix(16))
                                var formatted = ""
                                for (index, char) in limited.enumerated() {
                                    if index > 0 && index % 4 == 0 { formatted.append(" ") }
                                    formatted.append(char)
                                }
                                if viewModel.cardNumber != formatted { viewModel.cardNumber = formatted }
                            }
                        
                        HStack(spacing: 16) {
                            CardInputField(title: "EXPIRY (MM/YY)", placeholder: "12/26", text: $viewModel.expiry)
                                .onChange(of: viewModel.expiry) { _, newValue in
                                    let numbers = newValue.filter { $0.isNumber }
                                    let limited = String(numbers.prefix(4))
                                    var formatted = limited
                                    if limited.count > 2 {
                                        formatted.insert("/", at: formatted.index(formatted.startIndex, offsetBy: 2))
                                    }
                                    if viewModel.expiry != formatted { viewModel.expiry = formatted }
                                }
                            
                            CardInputField(title: "CVV", placeholder: "***", text: $viewModel.cvv)
                                .onChange(of: viewModel.cvv) { _, newValue in
                                    let numbers = newValue.filter { $0.isNumber }
                                    let limited = String(numbers.prefix(3))
                                    if viewModel.cvv != limited { viewModel.cvv = limited }
                                }
                        }
                    }
                }
                
                VStack(spacing: 12) {
                    HStack {
                        Text("Subtotal (\(viewModel.totalItems) items)")
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(viewModel.subtotalFormatted)
                            
                            if let usdText = viewModel.usdSubtotalFormatted {
                                Text(usdText)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    HStack {
                        Text("Shipping Fee")
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(viewModel.deliveryFeeFormatted)
                            
                            if let usdText = viewModel.usdDeliveryFeeFormatted {
                                Text(usdText)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    Divider()
                        .padding(.vertical, 4)
                    
                    HStack {
                        Text("Total Amount")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(viewModel.totalFormatted)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                            
                            if let usdText = viewModel.usdTotalFormatted {
                                Text(usdText)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
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
