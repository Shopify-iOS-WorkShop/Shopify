//
//  ContentView.swift
//  Shopify
//
//  Created by Ahmed Elkady on 27/06/2026.
//

import SwiftUI
import Auth
import Common
import Home
import search
import ProductDetails
import ProductListing
import ShopifyNetwork
import DataPersistence
import Cart

struct ContentView: View {
    @State private var appCoordinator = AppCoordinator()
    @State private var sessionChecked: Bool = false
    @State private var selectedTab: Common.Tab = .home
    @State private var cartViewModel: CartViewModel? = nil  // Initialize after session restore
    @StateObject private var homeViewModel: HomeViewModel = AppAssembly.shared.resolve(HomeViewModel.self)
    private let repository: AuthRepositoryProtocol = AuthRepositoryFactory.make()
    private let sessionStore: SessionStore = AppAssembly.shared.resolve(SessionStore.self)

    var body: some View {
        Group {
            if !sessionChecked {
                Color(uiColor: .systemBackground).ignoresSafeArea()
            } else if !appCoordinator.hasCompletedAuth {
                authFlow
            } else {
                mainFlow
            }
        }
        .task {
            // Restore session on app launch
            await restoreSession()
            sessionChecked = true
        }
        .onAppear {
            appCoordinator.productListingCoordinator.onNavigate = { [weak appCoordinator] route in
                if case .productDetail(let id) = route {
                    appCoordinator?.homeCoordinator.push(.productDetail(productId: id))
                }
            }
            
            // Wire cart icon tap in Home → switch to Cart tab
            appCoordinator.homeCoordinator.onCartTapped = { [self] in
                selectedTab = .cart
            }
        }
    }
    
    @MainActor
    private var authFlow: some View {
        NavigationStack(path: $appCoordinator.authCoordinator.path) {
            LoginView(viewModel: LoginViewModel())
                .navigationDestination(for: AuthRoute.self) { route in
                    authDestination(for: route)
                }
        }
        .environment(appCoordinator.authCoordinator)
    }
    @MainActor
    private var mainFlow: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedTab) {
                NavigationStack(path: $appCoordinator.homeCoordinator.path) {
                    HomeView(
                        viewModel: homeViewModel
                    )
                    .navigationDestination(for: HomeRoute.self) { route in
                        homeDestination(for: route)
                    }
                }
                .environment(appCoordinator.homeCoordinator)
                .tag(Common.Tab.home).toolbar(.hidden, for: .tabBar)
                SearchView()
                    .tag(Common.Tab.search)
                    .toolbar(.hidden, for: .tabBar)
                
                if let cartViewModel {
                    CartView(
                        viewModel: cartViewModel,
                        onGoShopping: {
                            selectedTab = .home
                        }
                    )
                    .tag(Common.Tab.cart)
                    .toolbar(.hidden, for: .tabBar)
                } else {
                    ProgressView()
                        .tag(Common.Tab.cart)
                        .toolbar(.hidden, for: .tabBar)
                }
                
                Text("Wishlist View").tag(Common.Tab.wishlist).toolbar(.hidden, for: .tabBar)
                Text("Account View").tag(Common.Tab.account).toolbar(.hidden, for: .tabBar)
            }
            .toolbar(.hidden, for: .tabBar)
            
            CustomTabBar(
                selectedTab: $selectedTab,
                cartBadgeCount: cartViewModel?.cartItemCount ?? 0
            )
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onChange(of: cartViewModel?.cartItemCount) { _, newValue in
            appCoordinator.homeCoordinator.cartBadgeCount = newValue ?? 0
        }
        .task {
            // Initialize cart badge count
            appCoordinator.homeCoordinator.cartBadgeCount = cartViewModel?.cartItemCount ?? 0
        }
    }
    
    @MainActor
    @ViewBuilder
    private func authDestination(for route: AuthRoute) -> some View {
        switch route {
        case .login:
            LoginView(viewModel: LoginViewModel())
        case .register:
            RegistrationView(viewModel: RegistrationViewModel())
        case .forgotPassword:
            ForgotPasswordView(viewModel: ForgotPasswordViewModel())
        case .setPassword(let email, let displayName):
            SetPasswordView(viewModel: SetPasswordViewModel(email: email, displayName: displayName))
        }
    }
    @MainActor
    @ViewBuilder
    private func homeDestination(for route: HomeRoute) -> some View {
        switch route {
        case .productListing(let collectionId, let title):
            let context: ListingContext = collectionId != nil ? .collection(id: collectionId!, title: title) : .allProducts
            
            ProductListingView(
                title: title,
                viewModel: ProductListingViewModel(
                    context: context,
                    repository: ProductListingRepository(networkClient: URLSessionNetworkClient())
                )
            )
            .environment(appCoordinator.productListingCoordinator)
            
        case .productDetail(let productId):
            ProductDetailFactory.makeView(
                productId: productId,
                onAddToCart: { [cartViewModel] variantId, quantity in
                    guard let cartViewModel else { return "Cart not initialized" }
                    return await cartViewModel.addLine(variantId: variantId, quantity: quantity)
                }
            )
            
        case .catalog(let type):
            CommonCatalogGridView(type: type) { selectedItem in
                appCoordinator.homeCoordinator.push(
                    .productListing(collectionId: selectedItem.id, title: selectedItem.name)
                )
            }
        }
    }
    
    // MARK: - Session Restoration
    
    @MainActor
    private func restoreSession() async {
        // Get persisted session from local storage
        guard let session = repository.currentSession(), session.isValid else {
            appCoordinator.hasCompletedAuth = false
            // Create cart for guest mode
            cartViewModel = AppAssembly.shared.resolve(CartViewModel.self)
            return
        }
        
        // Update SessionStore so all modules can access the session
        sessionStore.updateSession(session.toCommonSession())
        
        // NOW create CartViewModel with correct session
        cartViewModel = AppAssembly.shared.resolve(CartViewModel.self)
        
        // Mark auth as completed
        appCoordinator.hasCompletedAuth = true
    }
}


#Preview {
    ContentView()
}
