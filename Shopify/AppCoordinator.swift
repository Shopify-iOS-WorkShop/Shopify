//
//  AppCoordinator.swift
//  Shopify
//
//  Created by Mazen Amr on 03/07/2026.
//

import Foundation
import SwiftUI
import Observation
import Auth

@Observable
public final class AppCoordinator {
    public var hasCompletedAuth: Bool = false
    
    public var authCoordinator = AuthCoordinator()
    
    public init() {
        setupCallbacks()
    }
    
    private func setupCallbacks() {
        authCoordinator.onLoginSuccess = { [weak self] in
            self?.hasCompletedAuth = true
        }
        
        authCoordinator.onContinueAsGuest = { [weak self] in
            self?.hasCompletedAuth = true
        }
    }
}
