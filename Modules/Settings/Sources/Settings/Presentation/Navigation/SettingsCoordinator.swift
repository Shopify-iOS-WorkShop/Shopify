//
//  SettingsCoordinator.swift
//  Settings — Presentation
//

import Foundation
import SwiftUI

@Observable
public final class SettingsCoordinator {
    public var path = NavigationPath()
    public var isShowingAddresses = false

    /// Called by the app layer when sign-out is confirmed.
    /// Wired to Auth's SignOutUseCase in AppCoordinator.
    public var onSignOut: (() async -> Void)?

    public init() {}

    public func push(_ route: SettingsRoute) {
        path.append(route)
    }

    public func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    public func popToRoot() {
        path = NavigationPath()
    }
}
