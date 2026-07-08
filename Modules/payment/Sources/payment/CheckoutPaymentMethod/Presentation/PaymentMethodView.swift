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
                            .foregroundColor(DS.textSec)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(viewModel.subtotalFormatted)
                                .foregroundColor(DS.textPri)
                            
                            if let usdText = viewModel.usdSubtotalFormatted {
                                Text(usdText)
                                    .font(.caption)
                                    .foregroundColor(DS.textSec)
                            }
                        }
                    }
                    
                    HStack {
                        Text("Shipping Fee")
                            .foregroundColor(DS.textSec)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(viewModel.deliveryFeeFormatted)
                                .foregroundColor(DS.textPri)
                            
                            if let usdText = viewModel.usdDeliveryFeeFormatted {
                                Text(usdText)
                                    .font(.caption)
                                    .foregroundColor(DS.textSec)
                            }
                        }
                    }
                    
                    Divider()
                        .background(DS.border)
                        .padding(.vertical, 4)
                    
                    HStack {
                        Text("Total Amount")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(DS.textPri)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(viewModel.totalFormatted)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(DS.red)
                            
                            if let usdText = viewModel.usdTotalFormatted {
                                Text(usdText)
                                    .font(.caption)
                                    .foregroundColor(DS.textSec)
                            }
                        }
                    }
                }
                .padding()
                .background(DS.cardBG)
                .cornerRadius(12)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(DS.border, lineWidth: 1)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(DS.background.ignoresSafeArea())
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
        VStack(spacing: 12) {
            if viewModel.selectedMethod == .online {
                Button(action: {
                    print("Apple Pay Tapped")
                    viewModel.startApplePay()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "applelogo")
                            .font(.system(size: 18))
                        Text("Pay")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.6), lineWidth: 1.5)
                    }
                }
                .padding(.horizontal, 40)
                
                Text("OR PAY WITH CARD")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
            }
            
            CheckoutBottomButton(title: viewModel.isLoading ? "Processing..." : "Place Order") {
                Task {
                    await viewModel.processPayment()
                }
            }
            .disabled(viewModel.isLoading)
        }
        .padding(.top, 12)
        .background(
            DS.background
                .shadow(color: .black.opacity(0.15), radius: 12, y: -4)
        )
        .background(DS.background.ignoresSafeArea())
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
