//
//  File.swift
//  
//
//  Created by Mazen Amr on 04/07/2026.
//
import Foundation
import SwiftUI
import UIKit
import StripePayments
import StripeApplePay
import Stripe
import PassKit

@MainActor
public class PaymentMethodViewModel: NSObject, ObservableObject {
    
    @Published public var selectedMethod: PaymentType = .online
    @Published public var cardNumber: String = ""
    @Published public var expiry: String = ""
    @Published public var cvv: String = ""
    
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    @Published public var orderSuccess: Bool = false
    
    private var applePayContext: STPApplePayContext?
    private let placeOrderUseCase: PlaceOrderUseCaseProtocol
    private let cartItems: [CartItem]
    private let totalAmount: Double
    private let deliveryFee: Double
    private let address: CheckoutAddress
    private let customerId: String
    private let discountCodes: [String]
    private let discountAmount: Double
    
    private let currencyCode: String
    private let exchangeRate: Double
    
    public var totalItems: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }
    
    public var subtotalFormatted: String {
        let localValue = (totalAmount - deliveryFee) * exchangeRate
        return String(format: "%@ %.2f", currencyCode.uppercased(), localValue)
    }
    
    public var deliveryFeeFormatted: String {
        let localValue = deliveryFee * exchangeRate
        return String(format: "%@ %.2f", currencyCode.uppercased(), localValue)
    }
    
    public var totalFormatted: String {
        let localValue = totalAmount * exchangeRate
        return String(format: "%@ %.2f", currencyCode.uppercased(), localValue)
    }
    
    public var usdSubtotalFormatted: String? {
        guard currencyCode.uppercased() != "USD" else { return nil }
        let usdValue = totalAmount - deliveryFee
        return String(format: "(USD %.2f)", usdValue)
    }
    
    public var usdDeliveryFeeFormatted: String? {
        guard currencyCode.uppercased() != "USD" else { return nil }
        return String(format: "(USD %.2f)", deliveryFee)
    }
    
    public var usdTotalFormatted: String? {
        guard currencyCode.uppercased() != "USD" else { return nil }
        return String(format: "(USD %.2f)", totalAmount)
    }
    
    public init(
        placeOrderUseCase: PlaceOrderUseCaseProtocol,
        cartItems: [CartItem],
        totalAmount: Double,
        deliveryFee: Double,
        address: CheckoutAddress,
        customerId: String,
        discountCodes: [String] = [],
        discountAmount: Double = 0.0,
        currencyCode: String,
        exchangeRate: Double = 1.0
    ) {
        self.placeOrderUseCase = placeOrderUseCase
        self.cartItems = cartItems
        self.totalAmount = totalAmount
        self.deliveryFee = deliveryFee
        self.address = address
        self.customerId = customerId
        self.discountCodes = discountCodes
        self.discountAmount = discountAmount
        self.currencyCode = currencyCode
        self.exchangeRate = exchangeRate
        super.init()
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
                discountCodes: discountCodes,
                discountAmount: discountAmount,
                currencyCode: "USD",
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
    
    public func startApplePay() {
        print("DEBUG: startApplePay called")
        let pr = StripeAPI.paymentRequest(withMerchantIdentifier: "merchant.com.team5.test", country: "EG", currency: "USD")
        
        pr.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Subtotal", amount: NSDecimalNumber(value: totalAmount - deliveryFee)),
            PKPaymentSummaryItem(label: "Shipping", amount: NSDecimalNumber(value: deliveryFee)),
            PKPaymentSummaryItem(label: "Your Store Name", amount: NSDecimalNumber(value: totalAmount))
        ]
        
        if let applePayContext = STPApplePayContext(paymentRequest: pr, delegate: self) {
            self.applePayContext = applePayContext
            applePayContext.presentApplePay()
        } else {
            errorMessage = "Apple Pay is not configured or available on this device."
        }
    }
    
    private func finalizeOrderOnShopify() async {
        isLoading = true
        do {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = windowScene.windows.first(where: \.isKeyWindow)?.rootViewController else {
                errorMessage = "System error: Unable to present UI."
                return
            }

            let _ = try await placeOrderUseCase.execute(
                cartItems: cartItems,
                amount: totalAmount,
                deliveryFee: deliveryFee,
                address: address,
                customerId: customerId,
                discountCodes: discountCodes,
                discountAmount: discountAmount,
                currencyCode: "USD",
                paymentType: .applePay,
                cardNumber: "",
                expiry: "",
                cvv: "",
                viewController: rootViewController
            )
            orderSuccess = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

extension PaymentMethodViewModel: STPApplePayContextDelegate {
    
    public nonisolated func applePayContext(_ context: STPApplePayContext, didCreatePaymentMethod paymentMethod: STPPaymentMethod, paymentInformation: PKPayment, completion: @escaping STPIntentClientSecretCompletionBlock) {
        Task { @MainActor in
            do {
                let clientSecret = try await StripeChargeService.shared.fetchClientSecret(amount: self.totalAmount)
                completion(clientSecret, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    public nonisolated func applePayContext(_ context: STPApplePayContext, didCompleteWith status: STPPaymentStatus, error: Error?) {
        
        Task { @MainActor in
            switch status {
            case .success:
                await self.finalizeOrderOnShopify()
            case .error:
                self.errorMessage = error?.localizedDescription ?? "Payment failed."
            case .userCancellation:
                break
            @unknown default:
                break
            }
        }
    }
}
