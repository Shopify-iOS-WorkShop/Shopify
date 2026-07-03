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
public final class ProductListingCoordinator {
    public var onNavigate: ((ProductListingRoute) -> Void)?

    public init() {}
    
    public func push(_ route: ProductListingRoute) {
        onNavigate?(route)
    }
}
