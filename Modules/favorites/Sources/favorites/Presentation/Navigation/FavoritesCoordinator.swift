import Foundation
import SwiftUI
import Observation

@Observable
public final class FavoritesCoordinator {
    public var path = NavigationPath()
    public var onNavigateToDetail: ((Int) -> Void)?

    public init() {}

    public func push(_ route: FavoritesRoute) {
        path.append(route)
    }

    public func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
}
