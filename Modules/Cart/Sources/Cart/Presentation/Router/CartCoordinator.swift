import Foundation
import SwiftUI
import Observation

@Observable
public final class CartCoordinator {
    public var navigationPath = NavigationPath()

    // Callbacks set by AppCoordinator
    public var onCheckoutRequested: ((Cart) -> Void)?
    public var onProductDetailRequested: ((String, String) -> Void)?
    public var onSignInRequired: (() -> Void)?

    public init() {}

    public func start(viewModel: CartViewModel, onGoShopping: (() -> Void)? = nil) -> some View {
            viewModel.onCheckoutRequested = { [weak self, weak viewModel] in
                guard let cart = viewModel?.cart else { return }
                self?.navigateTo(.checkout(cart: cart))
        }
        return CartView(viewModel: viewModel, onGoShopping: onGoShopping)
    }

    public func navigateTo(_ route: CartRoute) {
        switch route {
        case .checkout(let cart):
            onCheckoutRequested?(cart)
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
