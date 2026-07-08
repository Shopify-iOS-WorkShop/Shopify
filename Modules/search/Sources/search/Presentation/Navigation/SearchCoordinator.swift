import Foundation
import SwiftUI
import Observation


@Observable
public final class SearchCoordinator {
    public var path = NavigationPath()

    public var onNavigateToDetail: ((Int) -> Void)?

    public var onNavigateToListing: ((String, String) -> Void)?

    public init() {}

    public func push(_ route: SearchRoute) {
        path.append(route)
    }

    public func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
}
