//
//  ContentView.swift
//  Shopify
//
//  Created by Ahmed Elkady on 27/06/2026.
//

import SwiftUI
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
                Color(.systemBackground).ignoresSafeArea()
            } else {
                if !appCoordinator.hasCompletedAuth {
                    NavigationStack(path: $appCoordinator.authCoordinator.path) {
                        LoginView(viewModel: LoginViewModel())
                            .navigationDestination(for: AuthRoute.self) { route in
                                switch route {
                                case .login:
                                    LoginView(viewModel: LoginViewModel())
                                case .register:
                                    RegistrationView(viewModel: RegistrationViewModel())
                                case .forgotPassword:
                                    ForgotPasswordView(viewModel: ForgotPasswordViewModel())
                                case .setPassword(let email, let displayName):
                                    let vm = SetPasswordViewModel(email: email, displayName: displayName)
                                    SetPasswordView(viewModel: vm)
                                }
                            }
                    }
                    .environment(appCoordinator.authCoordinator)
                    
                } else {
                    TabView {
                        NavigationStack(path: $appCoordinator.homeCoordinator.path) {
                            HomeView(
                                viewModel: HomeViewModel(
                                    repository: HomeRepository(networkClient: URLSessionNetworkClient())
                                )
                            )
                            .navigationDestination(for: HomeRoute.self) { route in
                                switch route {
                                case .productListing(let collectionId, let title):
                                    let repo = ProductListingRepository(networkClient: URLSessionNetworkClient())
                                    let context: ListingContext = collectionId != nil ? .collection(id: collectionId!, title: title) : .allProducts
                                    let vm = ProductListingViewModel(context: context, repository: repo)
                                    
                                    ProductListingView(title: title, viewModel: vm)
                                    
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
                        .environment(appCoordinator.homeCoordinator)
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                        
                    }
                }
            }
        }
        .task {
            if let session = repository.currentSession(), session.isValid {
                appCoordinator.hasCompletedAuth = true
            }
            sessionChecked = true
        }
    }
}

#Preview {
    ContentView()
}
