//
//  AddressCoordinator.swift
//  Address
//
//  Created by Mina Nashaat on 05/07/2026.
//

import Foundation
import SwiftUI

@Observable
public final class AddressCoordinator {
    public var path = NavigationPath()

    public var onAddressSelected: ((Address) -> Void)?

    public init() {}

    public func push(_ route: AddressRoute) {
        path.append(route)
    }

    public func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    public func popToRoot() {
        path.removeLast(path.count)
    }
}
