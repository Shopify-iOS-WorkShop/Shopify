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
                        NavigationStack {
                            HomeView(
                                viewModel: HomeViewModel(
                                    repository: HomeRepository(networkClient: URLSessionNetworkClient())
                                )
                            )
                        }
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
