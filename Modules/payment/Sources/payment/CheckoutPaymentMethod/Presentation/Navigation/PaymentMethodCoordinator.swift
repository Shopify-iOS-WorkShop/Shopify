//
//  File.swift
//  
//
//  Created by Mazen Amr on 06/07/2026.
//

import Foundation
import SwiftUI

public class PaymentMethodCoordinator: ObservableObject {
    @Published public var path = NavigationPath()
    
    public init() {}
    
    public func navigateToCheckoutResult() {
        path.append(PaymentMethodRoute.checkoutResult)
    }
    
    public func popToHome() {
        path.removeLast(path.count)
    }
    
    public func navigateToOrders() {
        popToHome()
    }
}
