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
 
public struct CartItem {
    public let variantId: String
    public let quantity: Int
 
    public init(variantId: String, quantity: Int) {
        self.variantId = variantId
        self.quantity = quantity
    }
}

public struct CheckoutAddress {
    public let address1: String
    public let city: String
    public let country: String
    public let firstName: String
    public let lastName: String
    public let phone: String
 
    public init(address1: String, city: String, country: String, firstName: String, lastName: String, phone: String) {
        self.address1 = address1
        self.city = city
        self.country = country
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
    }
}
 
public final class PaymentRepository: PaymentRepositoryProtocol {
 
    public init() {}
 
    private func perform<Mutation: GraphQLMutation>(_ mutation: Mutation) async throws -> Mutation.Data {
        try await withCheckedThrowingContinuation { continuation in
            AdminGraphQLClient.shared.apollo.perform(mutation: mutation) { result in
                switch result {
                case .success(let response):
                    if let data = response.data {
                        continuation.resume(returning: data)
                    } else {
                        let message = response.errors?.map { $0.message ?? "" }.joined(separator: ", ")
                            ?? "Unknown GraphQL Error"
                        continuation.resume(throwing: NSError(
                            domain: "PaymentError", code: -1,
                            userInfo: [NSLocalizedDescriptionKey: message]
                        ))
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
 
    private func buildDraftOrderInput(
        cartItems: [CartItem],
        deliveryFee: Double,
        address: CheckoutAddress,
        customerId: String
    ) -> ShopifyAdminAPI.DraftOrderInput {

        let formattedCustomerId = customerId.hasPrefix("gid://")
                ? customerId
                : "gid://shopify/Customer/\(customerId)"

        let purchasingEntity = ShopifyAdminAPI.PurchasingEntityInput(
            customerId: .some(formattedCustomerId)
        )
        
        let lineItems = cartItems.map { item in
            ShopifyAdminAPI.DraftOrderLineItemInput(
                quantity: item.quantity,
                variantId: .some(item.variantId)
            )
        }

        let parsedCountry = ShopifyAdminAPI.CountryCode(rawValue: address.country) ?? .eg
        let countryCodeEnum = GraphQLEnum<ShopifyAdminAPI.CountryCode>.case(parsedCountry)

        let shopifyAddress = ShopifyAdminAPI.MailingAddressInput(
            address1: .some(address.address1),
            city: .some(address.city),
            countryCode: .some(countryCodeEnum),
            firstName: .some(address.firstName),
            lastName: .some(address.lastName),
            phone: .some(address.phone)
        )

        let shippingLine = ShopifyAdminAPI.ShippingLineInput(
            priceWithCurrency: .some(
                ShopifyAdminAPI.MoneyInput(
                    amount: String(format: "%.2f", deliveryFee),
                    currencyCode: .case(.usd)
                )
            ),
            title: .some("Standard Shipping")
        )
        
        return ShopifyAdminAPI.DraftOrderInput(
            billingAddress: .some(shopifyAddress),
            lineItems: .some(lineItems),
            shippingAddress: .some(shopifyAddress),
            shippingLine: .some(shippingLine),
            purchasingEntity: .some(purchasingEntity)
        )
    }

    public func placeOnlineOrder(
        cartItems: [CartItem],
        amount: Double,
        deliveryFee: Double,
        address: CheckoutAddress,
        customerId: String,
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
            throw NSError(domain: "PaymentError", code: 3,
                          userInfo: [NSLocalizedDescriptionKey: "Card payment failed."])
        }
 
        let draftInput = buildDraftOrderInput(
            cartItems: cartItems,
            deliveryFee: deliveryFee,
            address: address,
            customerId: customerId
        )
 
        let createMutation = ShopifyAdminAPI.CreateDraftOrderMutation(input: draftInput)
        let createResult = try await perform(createMutation)
 
        if let errors = createResult.draftOrderCreate?.userErrors, !errors.isEmpty {
            throw NSError(domain: "PaymentError", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: errors.map { $0.message }.joined(separator: ", ")])
        }
 
        guard let draftOrderId = createResult.draftOrderCreate?.draftOrder?.id else {
            throw NSError(domain: "PaymentError", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Failed to create draft order."])
        }
 
        let completeMutation = ShopifyAdminAPI.CompleteDraftOrderAsPaidMutation(id: draftOrderId)
        let completeResult = try await perform(completeMutation)
 
        if let errors = completeResult.draftOrderComplete?.userErrors, !errors.isEmpty {
            throw NSError(domain: "PaymentError", code: 2,
                          userInfo: [NSLocalizedDescriptionKey: errors.map { $0.message }.joined(separator: ", ")])
        }
 
        guard let finalOrder = completeResult.draftOrderComplete?.draftOrder?.order else {
            throw NSError(domain: "PaymentError", code: 2,
                          userInfo: [NSLocalizedDescriptionKey: "Failed to complete draft order."])
        }
 
        return OrderInfo(id: finalOrder.id, orderNumber: finalOrder.name)
    }
 
    public func placeCODOrder(
        cartItems: [CartItem],
        deliveryFee: Double,
        address: CheckoutAddress,
        customerId: String
    ) async throws -> OrderInfo {
 
        let draftInput = buildDraftOrderInput(
            cartItems: cartItems,
            deliveryFee: deliveryFee,
            address: address,
            customerId: customerId
        )
 
        let createMutation = ShopifyAdminAPI.CreateDraftOrderMutation(input: draftInput)
        let createResult = try await perform(createMutation)
 
        if let errors = createResult.draftOrderCreate?.userErrors, !errors.isEmpty {
            throw NSError(domain: "PaymentError", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: errors.map { $0.message }.joined(separator: ", ")])
        }
 
        guard let draftOrderId = createResult.draftOrderCreate?.draftOrder?.id else {
            throw NSError(domain: "PaymentError", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Failed to create draft order."])
        }
 
        let completeMutation = ShopifyAdminAPI.CompleteDraftOrderAsCODMutation(
            id: draftOrderId,
            paymentGatewayId: .none
        )
        let completeResult = try await perform(completeMutation)
 
        if let errors = completeResult.draftOrderComplete?.userErrors, !errors.isEmpty {
            throw NSError(domain: "PaymentError", code: 2,
                          userInfo: [NSLocalizedDescriptionKey: errors.map { $0.message }.joined(separator: ", ")])
        }
 
        guard let finalOrder = completeResult.draftOrderComplete?.draftOrder?.order else {
            throw NSError(domain: "PaymentError", code: 2,
                          userInfo: [NSLocalizedDescriptionKey: "Failed to complete draft order."])
        }
 
        return OrderInfo(id: finalOrder.id, orderNumber: finalOrder.name)
    }
}
 
extension UIViewController: STPAuthenticationContext {
    public func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}
