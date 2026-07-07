//
//  ContentView.swift
//  Shopify
//
//  Created by Ahmed Elkady on 27/06/2026.
//

import SwiftUI
import Auth
import Addresss
import Common
import Home
import search
import ProductDetails
import ProductListing
import ShopifyNetwork
import DataPersistence
import Favorites
import Cart
import Payment
import Settings

enum GuestPromptContext {
    case addToCart
    case addToFavorites
    
    var title: String {
        switch self {
        case .addToCart: return "Sign In to Add to Cart"
        case .addToFavorites: return "Sign In to Add to Favorites"
        }
    }
    
    var message: String {
        switch self {
        case .addToCart:
            return "Please sign in to add items to your cart and manage your shopping."
        case .addToFavorites:
            return "Please sign in to save items to your favorites and access them across devices."
        }
    }
}

struct ContentView: View {


    @State private var appCoordinator = AppCoordinator()
    @StateObject private var favoritesViewModel = AppAssembly.shared.makeFavoritesViewModel()
    @StateObject private var searchViewModel = AppAssembly.shared.makeSearchViewModel()
    @State private var sessionChecked: Bool = false
    @State private var selectedTab: Common.Tab = .home
    @State private var cartViewModel: CartViewModel? = nil
    @State private var guestPromptContext: GuestPromptContext? = nil

    @AppStorage("settings_colorScheme") private var colorSchemeRaw: Int = 0
    @AppStorage("has_completed_onboarding") private var hasCompletedOnboarding: Bool = false

    @StateObject private var homeViewModel: HomeViewModel = AppAssembly.shared.resolve(HomeViewModel.self)
    @State private var settingsViewModel: SettingsViewModel = AppAssembly.shared.resolve(SettingsViewModel.self)
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
            } else if !hasCompletedOnboarding {
                OnBoardingScreen {
                    hasCompletedOnboarding = true
                }
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
        .task {
            // Exchange rates used to only load once the user visited Settings,
            // so Home showed unconverted prices until then. Fetch them once at
            // launch instead, in parallel with session restore, so CurrencyStore
            // is ready before Home (or anywhere else) needs to convert a price.
            await settingsViewModel.loadExchangeRates()
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
                    favoritesViewModel.clearFavorites()
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
            
            // Reload favorites to update Home view for the newly logged-in user
            favoritesViewModel.loadFavorites()
        }

        // ── Keep nav-bar cart badge in sync ──────────────────────────
        .onChange(of: cartViewModel?.cartItemCount) { _, count in
            appCoordinator.homeCoordinator.cartBadgeCount = count ?? 0
        }

        // ── Guest action prompt ───────────────────────────────────────
        .alert(
            guestPromptContext?.title ?? "Sign In Required",
            isPresented: Binding(
                get: { guestPromptContext != nil },
                set: { if !$0 {
                    guestPromptContext = nil
                    appCoordinator.showGuestSignInPrompt = false
                } }
            )
        ) {
            Button("Sign In") {
                appCoordinator.authCoordinator.path = NavigationPath()
                appCoordinator.hasCompletedAuth     = false
                guestPromptContext = nil
                appCoordinator.showGuestSignInPrompt = false
            }
            Button("Continue Browsing", role: .cancel) {
                guestPromptContext = nil
                appCoordinator.showGuestSignInPrompt = false
            }
        } message: {
            Text(guestPromptContext?.message ?? "Please sign in to access this feature.")
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
                            guard sessionStore.current != nil else {
                                guestPromptContext = .addToFavorites
                                return
                            }
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
                NavigationStack(path: $appCoordinator.cartCoordinator.navigationPath) {
                    Group {
                        if sessionStore.current == nil {
                            // Guest mode - show sign in prompt
                            GuestSignInView(
                                icon: "cart.badge.questionmark",
                                title: "Sign In to View Cart",
                                message: "Please sign in to add items to your cart and manage your shopping.",
                                onSignInTapped: {
                                    appCoordinator.authCoordinator.path = NavigationPath()
                                    appCoordinator.hasCompletedAuth = false
                                },
                                onBrowseTapped: { selectedTab = .home }
                            )
                            .navigationTitle("Cart")
                        } else if let cartViewModel {
                            CartView(
                                viewModel: cartViewModel,
                                onGoShopping: { selectedTab = .home },
                                onProductTapped: { productId in
                                    let rawId = productId.components(separatedBy: "/").last ?? productId
                                    appCoordinator.cartCoordinator.navigationPath.append(
                                        CartRoute.productDetails(productId: rawId, handle: "")
                                    )
                                }
                            )
                            .onAppear {
                                cartViewModel.onCheckoutRequested = {
                                    guard let cart = cartViewModel.cart else { return }
                                    appCoordinator.cartCoordinator.navigateTo(.checkout(cart: cart))
                                }
                                
                                cartViewModel.onSignInRequired = {
                                    appCoordinator.showGuestSignInPrompt = true
                                }
                            }
                        } else {
                            ProgressView()
                        }
                    }
                    .navigationDestination(for: CartRoute.self) { cartDestination(for: $0) }
                }
                .environment(appCoordinator.cartCoordinator)
                .tag(Common.Tab.cart)
                .toolbar(.hidden, for: .tabBar)

                // Wishlist tab
                NavigationStack(path: $appCoordinator.favoritesCoordinator.path) {
                    if sessionStore.current == nil {
                        // Guest mode - show sign in prompt
                        GuestSignInView(
                            icon: "heart.slash",
                            title: "Sign In to View Wishlist",
                            message: "Please sign in to save items to your favorites and access them across devices.",
                            onSignInTapped: {
                                appCoordinator.authCoordinator.path = NavigationPath()
                                appCoordinator.hasCompletedAuth = false
                            },
                            onBrowseTapped: { selectedTab = .home }
                        )
                        .navigationTitle("Wishlist")
                    } else {
                        FavoritesView(viewModel: favoritesViewModel)
                            .navigationDestination(for: FavoritesRoute.self) { favoritesDestination(for: $0) }
                    }
                }
                .environment(appCoordinator.favoritesCoordinator)
                .tag(Common.Tab.wishlist)
                .toolbar(.hidden, for: .tabBar)

                // Account tab
//                AddressFlowView(
//                    listViewModel: AppAssembly.shared.resolve(AddressListViewModel.self),
//                    viewModelFactory: AppAssembly.shared.resolve(AddressViewModelFactory.self)
//                )
//                .tag(Common.Tab.account)
//                .toolbar(.hidden, for: .tabBar)

                SettingsView(viewModel: settingsViewModel)
                    .environment(appCoordinator.settingsCoordinator)
                    .tag(Common.Tab.account)
                    .toolbar(.hidden, for: .tabBar)

            }
            .environment(currencyStore)
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
        .onChange(of: cartViewModel?.cartItemCount) { _, newValue in
            appCoordinator.homeCoordinator.cartBadgeCount = newValue ?? 0
        }
        .task {
            appCoordinator.homeCoordinator.cartBadgeCount = cartViewModel?.cartItemCount ?? 0
        }
        .fullScreenCover(isPresented: $appCoordinator.isShowingCheckout) {
            NavigationStack(path: $appCoordinator.checkoutAddressCoordinator.path) {
                CheckoutAddressView(
                    viewModel: AppAssembly.shared.resolve(CheckoutAddressViewModel.self)
                )
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            appCoordinator.isShowingCheckout = false
                            appCoordinator.checkoutAddressCoordinator.popToRoot()
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                    .fontWeight(.semibold)
                                Text("Cart")
                            }
                        }
                    }
                }
                .navigationDestination(for: CheckoutAddressRoute.self) { route in
                    switch route {
                    case .payment:
                        let safeAddress = appCoordinator.checkoutAddressCoordinator.selectedAddress
                            ?? CheckoutAddress(address1: "N/A", city: "N/A", country: "EG", firstName: "Customer", lastName: "", phone: "")
                        let customerId = sessionStore.current?.customerId ?? ""


                        PaymentMethodView(
                            viewModel: AppAssembly.shared.container.resolve(
                                PaymentMethodViewModel.self,
                                arguments:
                                    appCoordinator.checkoutAddressCoordinator.cartItems,
                                    appCoordinator.checkoutAddressCoordinator.totalAmount,
                                    appCoordinator.checkoutAddressCoordinator.deliveryFee,
                                    safeAddress,
                                    customerId,
                                    cartViewModel?.cart?.discountCodes.map { $0.code } ?? [],
                                    max(
                                        0,
                                        Double(truncating: cartViewModel?.cart?.cost.subtotalAmount.amount as? NSNumber ?? 0)
                                        -
                                        Double(truncating: cartViewModel?.cart?.cost.totalAmount.amount as? NSNumber ?? 0)
                                    ),
                                    currencyStore.selectedCurrency,
                                    currencyStore.exchangeRates?.convert(1.0, to: currencyStore.selectedCurrency) ?? 1.0
                            )!
                        )


                        case .success:
                            CheckoutResultView(
                                onTrackOrder: {
                                    Task { await cartViewModel?.confirmClearCart() }
                                    appCoordinator.checkoutAddressCoordinator.onCheckoutComplete?()
                                    selectedTab = .account
                                },
                                onContinueShopping: {
                                    Task { await cartViewModel?.confirmClearCart() }
                                    appCoordinator.checkoutAddressCoordinator.onCheckoutComplete?()
                                    selectedTab = .home
                                }
                            )
                    }
                }
            }
            .environment(appCoordinator.checkoutAddressCoordinator)
        }

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
        case .emailVerification(let email, let firstName, let lastName, let firebaseUID):
            EmailVerificationView(
                viewModel: EmailVerificationViewModel(
                    email: email,
                    firstName: firstName,
                    lastName: lastName,
                    firebaseUID: firebaseUID
                )
            )
        case .resetPassword(let email):
            // Note: oobCode would come from Firebase deep link
            // For now, this is a placeholder - actual implementation would extract oobCode from URL
            Text("Reset Password for \(email)")
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
                    guard sessionStore.current != nil else {
                        guestPromptContext = .addToFavorites
                        return
                    }
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
                        guestPromptContext = .addToCart
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
                    guard sessionStore.current != nil else {
                        guestPromptContext = .addToFavorites
                        return
                    }
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
                    guard sessionStore.current != nil else {
                        guestPromptContext = .addToCart
                        return nil
                    }
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
                    guard sessionStore.current != nil else {
                        guestPromptContext = .addToFavorites
                        return
                    }
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
                    guard sessionStore.current != nil else {
                        guestPromptContext = .addToCart
                        return nil
                    }
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
    @ViewBuilder
    private func cartDestination(for route: CartRoute) -> some View {
        switch route {
        case .productDetails(let productId, _):
            if let idInt = Int(productId) {
                ProductDetailFactory.makeView(
                    productId: idInt,
                    checkIsFavorite: { [weak favoritesViewModel] id in
                        favoritesViewModel?.isFavorite(productId: id) ?? false
                    },
                    onToggleFavorite: { [weak favoritesViewModel] id, title, vendor, price, rating, imageURL in
                        guard sessionStore.current != nil else {
                            guestPromptContext = .addToFavorites
                            return
                        }
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
                        guard sessionStore.current != nil else {
                            guestPromptContext = .addToCart
                            return nil
                        }
                        guard let cartViewModel else { return "Cart not initialized" }
                        return await cartViewModel.addLine(variantId: variantId, quantity: quantity)
                    }
                )
            } else {
                Text("Invalid product ID")
            }
        case .checkout, .signInRequired, .cart:
            EmptyView()
        }
    }



    @MainActor
    private func restoreSession() async {
    guard let session = repository.currentSession(), session.isValid else {
        sessionStore.clearSession()
                    appCoordinator.hasCompletedAuth = false
                    cartViewModel = AppAssembly.shared.resolve(CartViewModel.self)
                    return
                }
                
                sessionStore.updateSession(session.toCommonSession())
                cartViewModel = AppAssembly.shared.resolve(CartViewModel.self)
                appCoordinator.hasCompletedAuth = true
            }
        }

#Preview { ContentView() }
