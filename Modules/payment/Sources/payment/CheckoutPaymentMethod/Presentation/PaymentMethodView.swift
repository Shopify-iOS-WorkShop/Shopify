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
    @State private var selectedMethod: PaymentType = .online
    @State private var cardNumber: String = ""
    @State private var expiry: String = ""
    @State private var cvv: String = ""
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                CheckoutStepper(currentStep: .payment)
                    .padding(.top, 20)
                
                Text("Payment Method")
                    .font(.system(size: 20, weight: .bold))
                
                HStack(spacing: 12) {
                    PaymentMethodButton(title: "Online Payment", icon: "creditcard", type: .online, selectedMethod: $selectedMethod)
                    PaymentMethodButton(title: "Cash on Delivery", icon: "banknote", type: .cod, selectedMethod: $selectedMethod)
                }
                
                if selectedMethod == .online {
                    VStack(spacing: 16) {
                        CardInputField(title: "CARD NUMBER", placeholder: "0000 0000 0000 0000", text: $cardNumber, icon: "creditcard")
                        
                        HStack(spacing: 16) {
                            CardInputField(title: "EXPIRY (MM/YY)", placeholder: "12/26", text: $expiry)
                            CardInputField(title: "CVV", placeholder: "***", text: $cvv)
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
            CheckoutBottomButton(title: "Place Order") {
             
            }
        }
        .onTapGesture { UIApplication.shared.endEditing() }
    }
}
