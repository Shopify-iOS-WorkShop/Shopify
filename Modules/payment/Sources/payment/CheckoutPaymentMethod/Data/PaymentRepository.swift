//
//  File.swift
//  
//
//  Created by Mazen Amr on 04/07/2026.
//

import Foundation
import StripePayments
import ShopifyNetwork
import SwiftUI
import ShopifyAdminNetwork

public final class PaymentRepository: PaymentRepositoryProtocol {
    
    private let networkClient: NetworkClient
 
    public init(networkClient: NetworkClient = URLSessionNetworkClient()) {
        self.networkClient = networkClient
    }
 
    private func buildOrderPayload(
        cartItems: [CartItem],
        deliveryFee: Double,
        address: CheckoutAddress,
        customerId: String,
        discountCodes: [String],
        discountAmount: Double,
        isPaid: Bool
    ) -> RESTOrderPayload {
        
        let rawCustomerId = Int(customerId.components(separatedBy: "/").last ?? customerId) ?? 0
        
        let lineItems = cartItems.map { item in
            let rawVariantId = Int(item.variantId.components(separatedBy: "/").last ?? item.variantId) ?? 0
            return RESTLineItem(variant_id: rawVariantId, quantity: item.quantity)
        }
        
        let restAddress = RESTAddress(
            first_name: address.firstName,
            last_name: address.lastName,
            address1: address.address1,
            city: address.city,
            country: address.country,
            phone: address.phone
        )
        
        let shippingLine = RESTShippingLine(
            title: "Standard Shipping",
            price: String(format: "%.2f", deliveryFee)
        )
        
        let restDiscounts = discountCodes.map {
            RESTDiscountCode(code: $0, amount: String(format: "%.2f", discountAmount), type: "fixed_amount")
        }
        
        let orderData = RESTOrderData(
            line_items: lineItems,
            customer: RESTCustomer(id: rawCustomerId),
            billing_address: restAddress,
            shipping_address: restAddress,
            financial_status: isPaid ? "paid" : "pending",
            shipping_lines: [shippingLine],
            discount_codes: restDiscounts.isEmpty ? nil : restDiscounts,
            currency: "USD",
            presentment_currency: "USD"
        )
        
        return RESTOrderPayload(order: orderData)
    }
    
    public func placeOnlineOrder(
        cartItems: [CartItem],
        amount: Double,
        deliveryFee: Double,
        address: CheckoutAddress,
        customerId: String,
        discountCodes: [String],
        discountAmount: Double,
        cardNumber: String,
        expMonth: UInt,
        expYear: UInt,
        cvv: String,
        viewController: UIViewController
    ) async throws -> OrderInfo {
        let clientSecret = try await StripeChargeService.shared.fetchClientSecret(amount: amount)
        let cardParams = STPPaymentMethodCardParams()
        cardParams.number = cardNumber
        cardParams.expMonth = NSNumber(value: expMonth)
        cardParams.expYear = NSNumber(value: expYear)
        cardParams.cvc = cvv
 
        let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
        paymentIntentParams.paymentMethodParams = paymentMethodParams
 
        let paymentHandler = STPPaymentHandler.shared()
        let confirmStatus: STPPaymentHandlerActionStatus = try await withCheckedThrowingContinuation { continuation in
            paymentHandler.confirmPayment(paymentIntentParams, with: viewController) { status, _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: status)
                }
            }
        }
 
        guard confirmStatus == .succeeded else {
            throw NSError(domain: "PaymentError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Card payment failed."])
        }
 
        let payload = buildOrderPayload(
            cartItems: cartItems,
            deliveryFee: deliveryFee,
            address: address,
            customerId: customerId,
            discountCodes: discountCodes,
            discountAmount: discountAmount,
            isPaid: true
        )
        let endpoint = CreateOrderEndpoint(payload: payload)
        let result: RESTOrderResponse = try await networkClient.request(endpoint: endpoint)
 
        return OrderInfo(id: "gid://shopify/Order/\(result.order.id)", orderNumber: result.order.name)
    }
 
    public func placeCODOrder(
        cartItems: [CartItem],
        deliveryFee: Double,
        address: CheckoutAddress,
        customerId: String,
        discountCodes: [String],
        discountAmount: Double
    ) async throws -> OrderInfo {
        
        let payload = buildOrderPayload(
            cartItems: cartItems,
            deliveryFee: deliveryFee,
            address: address,
            customerId: customerId,
            discountCodes: discountCodes,
            discountAmount: discountAmount,
            isPaid: false
        )
 
        let endpoint = CreateOrderEndpoint(payload: payload)
        let result: RESTOrderResponse = try await networkClient.request(endpoint: endpoint)
        
        return OrderInfo(id: "gid://shopify/Order/\(result.order.id)", orderNumber: result.order.name)
    }

    public func placeApplePayOrder(
        cartItems: [CartItem],
        deliveryFee: Double,
        address: CheckoutAddress,
        customerId: String,
        discountCodes: [String],
        discountAmount: Double
    ) async throws -> OrderInfo {
        
        let payload = buildOrderPayload(
            cartItems: cartItems,
            deliveryFee: deliveryFee,
            address: address,
            customerId: customerId,
            discountCodes: discountCodes,
            discountAmount: discountAmount,
            isPaid: true
        )
 
        let endpoint = CreateOrderEndpoint(payload: payload)
        let result: RESTOrderResponse = try await networkClient.request(endpoint: endpoint)
        
        return OrderInfo(id: "gid://shopify/Order/\(result.order.id)", orderNumber: result.order.name)
    }
}
 
extension UIViewController: STPAuthenticationContext {
    public func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}
