//
//  ContentView.swift
//  Shopify
//
//  Created by Ahmed Elkady on 27/06/2026.
//

import SwiftUI
import UIKit
import ShopifyNetwork
import Home
import Auth
import ProductListing
import ProductDetails
import Common

struct ContentView: View {
    @State private var appCoordinator = AppCoordinator()
    @State private var sessionChecked: Bool = false
    private let repository: AuthRepositoryProtocol = AuthRepositoryFactory.make()

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
            if let session = repository.currentSession(), session.isValid {
                appCoordinator.hasCompletedAuth = true
            }
            sessionChecked = true
        }
        .onAppear {
            appCoordinator.productListingCoordinator.onNavigate = { [weak appCoordinator] route in
                if case .productDetail(let id) = route {
                    appCoordinator?.homeCoordinator.push(.productDetail(productId: id))
                }
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
        TabView {
            NavigationStack(path: $appCoordinator.homeCoordinator.path) {
                HomeView(
                    viewModel: HomeViewModel(
                        repository: HomeRepository(networkClient: URLSessionNetworkClient())
                    )
                )
                .navigationDestination(for: HomeRoute.self) { route in
                    homeDestination(for: route)
                }
            }
            .environment(appCoordinator.homeCoordinator)
            .tabItem {
                Label("Home", systemImage: "house")
            }
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
            ProductDetailFactory.makeView(productId: productId)
            
        case .catalog(let type):
            CommonCatalogGridView(type: type) { selectedItem in
                appCoordinator.homeCoordinator.push(
                    .productListing(collectionId: selectedItem.id, title: selectedItem.name)
                )
            }
        }
    }
}

#Preview {
    ContentView()
}
