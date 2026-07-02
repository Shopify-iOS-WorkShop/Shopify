import Foundation
import SwiftUI
import Observation

@Observable
public final class CartCoordinator {
    public var navigationPath = NavigationPath()

    // Callbacks set by AppCoordinator
    public var onCheckoutRequested: ((URL?) -> Void)?
    public var onProductDetailRequested: ((String, String) -> Void)?
    public var onSignInRequired: (() -> Void)?

    public init() {}

    // Temporary placeholder for the CartView until it's implemented in task/cart-ui
    public func start() -> some View {
        Text("Cart View Placeholder")
    }

    public func navigateTo(_ route: CartRoute, currentCheckoutUrl: URL? = nil) {
        switch route {
        case .checkout:
            onCheckoutRequested?(currentCheckoutUrl)
        case .productDetails(let id, let handle):
            onProductDetailRequested?(id, handle)
        case .signInRequired:
            onSignInRequired?()
        case .cart:
            break
        }
    }

    public func goBack() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
}
