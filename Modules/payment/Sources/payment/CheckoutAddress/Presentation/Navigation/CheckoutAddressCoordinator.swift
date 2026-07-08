//
//  File.swift
//  
//
//  Created by Mazen Amr on 03/07/2026.
//

import Foundation
import SwiftUI
import Observation

@Observable
public final class CheckoutAddressCoordinator {
    public var path = NavigationPath()
    
    public var onCheckoutComplete: (() -> Void)?
    public var onAddNewAddressRequested: (() -> Void)?
    public var selectedAddress: CheckoutAddress?
    public var cartItems: [CartItem] = []
    public var totalAmount: Double = 0.0
    public var deliveryFee: Double = 0.0
    
    public init() {}
    
    public func push(_ route: CheckoutAddressRoute) {
        path.append(route)
    }
    
    public func popToRoot() {
        path.removeLast(path.count)
    }
}
