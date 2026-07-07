//
//  File.swift
//
//
//  Created by Mazen Amr on 04/07/2026.
//

import Foundation
import UIKit

public protocol PlaceOrderUseCaseProtocol {
    func execute(
        cartItems: [CartItem],
        amount: Double,
        deliveryFee: Double,
        address: CheckoutAddress,
        customerId: String,
        discountCodes: [String],
        discountAmount: Double,
        currencyCode: String,
        paymentType: PaymentType,
        cardNumber: String,
        expiry: String,
        cvv: String,
        viewController: UIViewController
    ) async throws -> OrderInfo
}

public final class PlaceOrderUseCase: PlaceOrderUseCaseProtocol {
    private let repository: PaymentRepositoryProtocol
    
    public init(repository: PaymentRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(
        cartItems: [CartItem],
        amount: Double,
        deliveryFee: Double,
        address: CheckoutAddress,
        customerId: String,
        discountCodes: [String],
        discountAmount: Double,
        currencyCode: String,
        paymentType: PaymentType,
        cardNumber: String,
        expiry: String,
        cvv: String,
        viewController: UIViewController
    ) async throws -> OrderInfo {
        switch paymentType {
        case .online:
            let components = expiry.split(separator: "/")
            guard components.count == 2,
                  let month = UInt(components[0]),
                  let year = UInt(components[1]) else {
                throw NSError(domain: "Payment", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid expiry date format. Use MM/YY."])
            }
            
            let cleanCardNumber = cardNumber.replacingOccurrences(of: " ", with: "")
            let fullYear = year < 100 ? year + 2000 : year
            
            return try await repository.placeOnlineOrder(
                cartItems: cartItems,
                amount: amount,
                deliveryFee: deliveryFee,
                address: address,
                customerId: customerId,
                discountCodes: discountCodes,
                discountAmount: discountAmount,
                cardNumber: cleanCardNumber,
                expMonth: month,
                expYear: fullYear,
                cvv: cvv,
                viewController: viewController
            )
            
        case .cod:
            return try await repository.placeCODOrder(
                cartItems: cartItems,
                deliveryFee: deliveryFee,
                address: address,
                customerId: customerId,
                discountCodes: discountCodes,
                discountAmount: discountAmount
            )
        }
    }
}
