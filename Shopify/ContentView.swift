//
//  ContentView.swift
//  Shopify
//
//  Created by Ahmed Elkady on 27/06/2026.
//

import SwiftUI
import Auth
import Address
import Common
import Home
import search
import ProductDetails
import ProductListing
import ShopifyNetwork
import DataPersistence
import Favorites
import Cart

struct ContentView: View {
    @State private var appCoordinator = AppCoordinator()
    @StateObject private var favoritesViewModel = AppAssembly.shared.makeFavoritesViewModel()
    @StateObject private var searchViewModel = AppAssembly.shared.makeSearchViewModel()
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
            
            // Load setup for favorites
            favoritesViewModel.loadFavorites()
            
            // Wire cart icon tap in Home → switch to Cart tab
            appCoordinator.homeCoordinator.onCartTapped = {
                selectedTab = .cart
            }
        }
    }

    // MARK: - Auth flow

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

    // MARK: - Main flow

    @MainActor
    private var mainFlow: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedTab) {
                // Home tab
                NavigationStack(path: $appCoordinator.homeCoordinator.path) {
                    HomeView(
                        viewModel: homeViewModel,
                        favoritedIDs: favoritesViewModel.favoritedIDs,
                        onFavoriteTap: { product in
                            favoritesViewModel.toggleFavorite(
                                product: FavoriteProduct(
                                    id: product.id,
                                    title: product.title,
                                    vendor: product.vendor,
                                    price: product.price,
                                    rating: product.rating,
                                    imageURL: product.imageURL,
                                    productType: "",
                                    isInStock: true
                                )
                            )
                        }
                    )
                    .navigationDestination(for: HomeRoute.self) { route in
                        homeDestination(for: route)
                    }
                }
                .environment(appCoordinator.homeCoordinator)
                .tag(Common.Tab.home)
                .toolbar(.hidden, for: .tabBar)

                // Search tab
                NavigationStack(path: $appCoordinator.searchCoordinator.path) {
                    SearchView(viewModel: searchViewModel)
                        .navigationDestination(for: SearchRoute.self) { route in
                            searchDestination(for: route)
                        }
                }
                .environment(appCoordinator.searchCoordinator)
                .tag(Common.Tab.search)
                .toolbar(.hidden, for: .tabBar)

                // Cart tab
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

                // Wishlist tab
                NavigationStack(path: $appCoordinator.favoritesCoordinator.path) {
                    FavoritesView(viewModel: favoritesViewModel)
                        .navigationDestination(for: FavoritesRoute.self) { route in
                            favoritesDestination(for: route)
                        }
                }
                .environment(appCoordinator.favoritesCoordinator)
                .tag(Common.Tab.wishlist)
                .toolbar(.hidden, for: .tabBar)

                // Account tab
//                Text("Account View").tag(Common.Tab.account).toolbar(.hidden, for: .tabBar)
                AddressFlowView(
                    listViewModel: AppAssembly.shared.resolve(AddressListViewModel.self),
                    viewModelFactory: AppAssembly.shared.resolve(AddressViewModelFactory.self)
                )
                .tag(Common.Tab.account)
                .toolbar(.hidden, for: .tabBar)
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

    // MARK: - Destinations

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
            let context: ListingContext = collectionId != nil
                ? .collection(id: collectionId!, title: title)
                : .allProducts

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
                checkIsFavorite: { [weak favoritesViewModel] id in
                    favoritesViewModel?.isFavorite(productId: id) ?? false
                },
                onToggleFavorite: { [weak favoritesViewModel] id, title, vendor, price, rating, imageURL in
                    guard let vm = favoritesViewModel else { return }
                    if vm.isFavorite(productId: id) {
                        vm.remove(productId: id)
                    } else {
                        vm.add(product: FavoriteProduct(
                            id: id,
                            title: title,
                            vendor: vendor,
                            price: price,
                            rating: rating,
                            imageURL: imageURL.flatMap(URL.init(string:)),
                            productType: "",
                            isInStock: true
                        ))
                    }
                },
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

    @MainActor
    @ViewBuilder
    private func favoritesDestination(for route: FavoritesRoute) -> some View {
        switch route {
        case .productDetail(let productId):
            ProductDetailFactory.makeView(
                productId: productId,
                checkIsFavorite: { [weak favoritesViewModel] id in
                    favoritesViewModel?.isFavorite(productId: id) ?? false
                },
                onToggleFavorite: { [weak favoritesViewModel] id, title, vendor, price, rating, imageURL in
                    guard let vm = favoritesViewModel else { return }
                    if vm.isFavorite(productId: id) {
                        vm.remove(productId: id)
                    } else {
                        vm.add(product: FavoriteProduct(
                            id: id,
                            title: title,
                            vendor: vendor,
                            price: price,
                            rating: rating,
                            imageURL: imageURL.flatMap(URL.init(string:)),
                            productType: "",
                            isInStock: true
                        ))
                    }
                },
                onAddToCart: { [cartViewModel] variantId, quantity in
                    guard let cartViewModel else { return "Cart not initialized" }
                    return await cartViewModel.addLine(variantId: variantId, quantity: quantity)
                }
            )
        }
    }

    @MainActor
    @ViewBuilder
    private func searchDestination(for route: SearchRoute) -> some View {
        switch route {
        case .productDetail(let productId):
            ProductDetailFactory.makeView(
                productId: productId,
                checkIsFavorite: { [weak favoritesViewModel] id in
                    favoritesViewModel?.isFavorite(productId: id) ?? false
                },
                onToggleFavorite: { [weak favoritesViewModel] id, title, vendor, price, rating, imageURL in
                    guard let vm = favoritesViewModel else { return }
                    if vm.isFavorite(productId: id) {
                        vm.remove(productId: id)
                    } else {
                        vm.add(product: FavoriteProduct(
                            id: id,
                            title: title,
                            vendor: vendor,
                            price: price,
                            rating: rating,
                            imageURL: imageURL.flatMap(URL.init(string:)),
                            productType: "",
                            isInStock: true
                        ))
                    }
                },
                onAddToCart: { [cartViewModel] variantId, quantity in
                    guard let cartViewModel else { return "Cart not initialized" }
                    return await cartViewModel.addLine(variantId: variantId, quantity: quantity)
                }
            )
        case .productListing(let collectionId, let title):
            let context: ListingContext = .collection(id: collectionId, title: title)
            ProductListingView(
                title: title,
                viewModel: ProductListingViewModel(
                    context: context,
                    repository: ProductListingRepository(networkClient: URLSessionNetworkClient())
                )
            )
            .environment(appCoordinator.productListingCoordinator)
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
