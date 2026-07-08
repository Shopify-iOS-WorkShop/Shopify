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
public final class HomeCoordinator {
    public var path = NavigationPath()
    public var onCartTapped: (() -> Void)?
    public var onMenuTapped: (() -> Void)?
    public var cartBadgeCount: Int = 0
    
    public init() {}
    
    public func push(_ route: HomeRoute) {
        path.append(route)
    }
    
    public func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}

