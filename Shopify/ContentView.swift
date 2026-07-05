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
import Favorites
import Cart
import Settings

struct ContentView: View {


    @State private var appCoordinator = AppCoordinator()
    @StateObject private var favoritesViewModel = AppAssembly.shared.makeFavoritesViewModel()
    @StateObject private var searchViewModel = AppAssembly.shared.makeSearchViewModel()
    @State private var sessionChecked: Bool = false
    @State private var selectedTab: Common.Tab = .home
    @State private var cartViewModel: CartViewModel? = nil

   
    @AppStorage("settings_colorScheme") private var colorSchemeRaw: Int = 0


    @StateObject private var homeViewModel: HomeViewModel =
        AppAssembly.shared.resolve(HomeViewModel.self)

    @State private var settingsViewModel: SettingsViewModel =
        AppAssembly.shared.resolve(SettingsViewModel.self)

    private let repository: AuthRepositoryProtocol = AuthRepositoryFactory.make()
    private let sessionStore: SessionStore         = AppAssembly.shared.resolve(SessionStore.self)
    
    private let currencyStore: CurrencyStore       = AppAssembly.shared.resolve(CurrencyStore.self)


    private var preferredColorScheme: ColorScheme? {
        switch colorSchemeRaw {
        case 1: return .light
        case 2: return .dark
        default: return nil
        }
    }


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
        .preferredColorScheme(preferredColorScheme)

        .task {
            await restoreSession()
            sessionChecked = true
        }

        .onAppear {
            appCoordinator.productListingCoordinator.onNavigate = { [weak appCoordinator] route in
                if case .productDetail(let id) = route {
                    appCoordinator?.homeCoordinator.push(.productDetail(productId: id))
                }
            }

            
            favoritesViewModel.loadFavorites()
            
           
            appCoordinator.homeCoordinator.onCartTapped = { [self] in
                selectedTab = .cart
            }

            
            appCoordinator.settingsCoordinator.onSignOut = { [self] in
                _ = await repository.signOut()
                await MainActor.run {
                    // Pop every NavigationStack to its root
                    appCoordinator.homeCoordinator.path   = NavigationPath()
                    appCoordinator.authCoordinator.path   = NavigationPath() // ensures Login, not Register
                    appCoordinator.settingsCoordinator.popToRoot()
                    // Clear data
                    sessionStore.clearSession()
                    cartViewModel = nil
                    selectedTab   = .home
                    // Show login screen
                    appCoordinator.hasCompletedAuth = false
                }
            }

            
            settingsViewModel.onSignIn = { [self] in
                appCoordinator.authCoordinator.path = NavigationPath()
                appCoordinator.hasCompletedAuth     = false
            }
        }

       
        .onChange(of: appCoordinator.hasCompletedAuth) { _, isAuthenticated in
            guard isAuthenticated else { return }
            selectedTab = .home
            appCoordinator.homeCoordinator.path = NavigationPath() // always show initial Home
            // Recreate cart (picks up new session owner key) and load immediately
            cartViewModel = AppAssembly.shared.resolve(CartViewModel.self)
            Task { await cartViewModel?.onAppear() }
        }

        // ── Keep nav-bar cart badge in sync ──────────────────────────
        .onChange(of: cartViewModel?.cartItemCount) { _, count in
            appCoordinator.homeCoordinator.cartBadgeCount = count ?? 0
        }

        // ── Guest action prompt ───────────────────────────────────────
        .alert("Sign In Required", isPresented: $appCoordinator.showGuestSignInPrompt) {
            Button("Sign In") {
                appCoordinator.authCoordinator.path = NavigationPath()
                appCoordinator.hasCompletedAuth     = false
            }
            Button("Continue Browsing", role: .cancel) {}
        } message: {
            Text("Please sign in to add items to your cart and access your account.")
        }
    }


    @MainActor
    private var authFlow: some View {
        NavigationStack(path: $appCoordinator.authCoordinator.path) {
            LoginView(viewModel: LoginViewModel())
                .navigationDestination(for: AuthRoute.self) { authDestination(for: $0) }
        }
        .environment(appCoordinator.authCoordinator)
    }


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
                    .navigationDestination(for: HomeRoute.self) { homeDestination(for: $0) }
                }
                .environment(appCoordinator.homeCoordinator)
                .tag(Common.Tab.home)
                .toolbar(.hidden, for: .tabBar)

                // Search tab
                NavigationStack(path: $appCoordinator.searchCoordinator.path) {
                    SearchView(viewModel: searchViewModel)
                        .navigationDestination(for: SearchRoute.self) { searchDestination(for: $0) }
                }
                .environment(appCoordinator.searchCoordinator)
                .tag(Common.Tab.search)
                .toolbar(.hidden, for: .tabBar)

                // Cart tab
                Group {
                    if let cartViewModel {
                        CartView(
                            viewModel: cartViewModel,
                            onGoShopping: { selectedTab = .home },
                            onProductTapped: { productId in
                                let rawId = productId.components(separatedBy: "/").last ?? productId
                                if let idInt = Int(rawId) {
                                    appCoordinator.homeCoordinator.push(.productDetail(productId: idInt))
                                    selectedTab = .home
                                }
                            }
                        )
                    } else {
                        ProgressView()
                    }
                }
                .tag(Common.Tab.cart)
                .toolbar(.hidden, for: .tabBar)

                NavigationStack(path: $appCoordinator.favoritesCoordinator.path) {
                    FavoritesView(viewModel: favoritesViewModel)
                        .navigationDestination(for: FavoritesRoute.self) { favoritesDestination(for: $0) }
                }
                .environment(appCoordinator.favoritesCoordinator)
                .tag(Common.Tab.wishlist)
                .toolbar(.hidden, for: .tabBar)

                // Account tab
                SettingsView(viewModel: settingsViewModel)
                    .environment(appCoordinator.settingsCoordinator)
                    .tag(Common.Tab.account)
                    .toolbar(.hidden, for: .tabBar)
            }
            .environment(currencyStore) // Available globally to all tabs
            .toolbar(.hidden, for: .tabBar)

            CustomTabBar(
                selectedTab: $selectedTab,
                cartBadgeCount: cartViewModel?.cartItemCount ?? 0,
                onTabTapped: { tappedTab in
                    if tappedTab == .account {
                        appCoordinator.settingsCoordinator.popToRoot()
                    }
                }
            )
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }


    @MainActor @ViewBuilder
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

    @MainActor @ViewBuilder
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
                    // Block guests — sessionStore is a class ref, checked at call time
                    guard sessionStore.current != nil else {
                        appCoordinator.showGuestSignInPrompt = true
                        return nil
                    }
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



    @MainActor
    private func restoreSession() async {
        guard let session = repository.currentSession(), session.isValid else {
            sessionStore.clearSession()
            // No valid session — show the Login screen.
            // hasCompletedAuth stays false (its default), so authFlow is displayed.
            // The user can log in or tap "Continue as Guest" from the Login screen.
            return
        }
        sessionStore.updateSession(session.toCommonSession())
        // Authenticated: onChange will create + load cartViewModel
        appCoordinator.hasCompletedAuth = true
    }
}

#Preview { ContentView() }
