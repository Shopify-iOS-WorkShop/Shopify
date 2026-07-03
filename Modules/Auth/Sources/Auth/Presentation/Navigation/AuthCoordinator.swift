//
//  File.swift
//  
//
//  Created by Mazen Amr on 03/07/2026.
//

import Foundation
import SwiftUI

@Observable
public final class AuthCoordinator {
    public var path = NavigationPath()
    
    public var onLoginSuccess: (() -> Void)?
    public var onContinueAsGuest: (() -> Void)?
    
    public init() {}
    
    public func push(_ route: AuthRoute) {
        path.append(route)
    }
    
    public func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}
