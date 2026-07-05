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
            if cardNumber.isEmpty || expiry.isEmpty || cvv.isEmpty {
                errorMessage = "Please fill in all card details."
                return false
            }
        }
        return true
    }
}
