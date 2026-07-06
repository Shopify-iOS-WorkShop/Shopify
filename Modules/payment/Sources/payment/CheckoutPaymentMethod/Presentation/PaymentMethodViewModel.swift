//
//  File.swift
//  
//
//  Created by Mazen Amr on 04/07/2026.
//
import Foundation
import SwiftUI
import UIKit

@MainActor
public class PaymentMethodViewModel: ObservableObject {
    @Published public var selectedMethod: PaymentType = .online
    @Published public var cardNumber: String = ""
    @Published public var expiry: String = ""
    @Published public var cvv: String = ""
    
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    @Published public var orderSuccess: Bool = false
    
    private let placeOrderUseCase: PlaceOrderUseCaseProtocol
    private let cartItems: [CartItem]
    private let totalAmount: Double
    private let deliveryFee: Double
    private let address: CheckoutAddress
    private let customerId: String
    
    public var totalItems: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }
    
    public var subtotalFormatted: String {
        String(format: "$%.2f", totalAmount - deliveryFee)
    }
    
    public var deliveryFeeFormatted: String {
        String(format: "$%.2f", deliveryFee)
    }
    
    public var totalFormatted: String {
        String(format: "$%.2f", totalAmount)
    }
    
    
    public init(
        placeOrderUseCase: PlaceOrderUseCaseProtocol,
        cartItems: [CartItem],
        totalAmount: Double,
        deliveryFee: Double,
        address: CheckoutAddress,
        customerId: String
    ) {
        self.placeOrderUseCase = placeOrderUseCase
        self.cartItems = cartItems
        self.totalAmount = totalAmount
        self.deliveryFee = deliveryFee
        self.address = address
        self.customerId = customerId
    }
    
    public func processPayment() async {
        guard validateInputs() else { return }
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first(where: \.isKeyWindow)?.rootViewController else {
            errorMessage = "System error: Unable to present payment verification."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let _ = try await placeOrderUseCase.execute(
                cartItems: cartItems,
                amount: totalAmount,
                deliveryFee: deliveryFee,
                address: address,
                customerId: customerId,
                paymentType: selectedMethod,
                cardNumber: cardNumber,
                expiry: expiry,
                cvv: cvv,
                viewController: rootViewController
            )
            orderSuccess = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func validateInputs() -> Bool {
        if selectedMethod == .online {
            let cleanCard = cardNumber.filter { $0.isNumber }
            let cleanExpiry = expiry.filter { $0.isNumber }
            
            if cleanCard.isEmpty || cleanExpiry.isEmpty || cvv.isEmpty {
                errorMessage = "Please fill in all card details."
                return false
            }
            if cleanCard.count != 16 {
                errorMessage = "Card number must be exactly 16 digits."
                return false
            }
            if cleanExpiry.count != 4 {
                errorMessage = "Please complete the expiry date (MM/YY)."
                return false
            }
            if cvv.count != 3 {
                errorMessage = "CVV must be exactly 3 digits."
                return false
            }
        }
        return true
    }
}
