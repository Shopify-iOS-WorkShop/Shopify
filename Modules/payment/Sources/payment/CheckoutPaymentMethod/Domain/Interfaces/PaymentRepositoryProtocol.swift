//
//  File.swift
//  
//
//  Created by Mazen Amr on 04/07/2026.
//

import Foundation
import SwiftUI

public protocol PaymentRepositoryProtocol {
    func placeOnlineOrder(
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
    ) async throws -> OrderInfo

    func placeCODOrder(
        cartItems: [CartItem],
        deliveryFee: Double,
        address: CheckoutAddress,
        customerId: String,
        discountCodes: [String],
        discountAmount: Double
    ) async throws -> OrderInfo
}
