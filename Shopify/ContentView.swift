//
//  ContentView.swift
//  Shopify
//
//  Created by Ahmed Elkady on 27/06/2026.
//

import SwiftUI
import Auth
import Home
import ShopifyNetwork

ً
private enum AppScreen: Equatable {
    case login
    case registration
    case forgotPassword
    case setPassword(email: String, displayName: String?)
    case home
}


struct ContentView: View {

    @State private var appScreen: AppScreen = .login
    @State private var sessionChecked: Bool = false

    @StateObject private var loginViewModel       = LoginViewModel()
    @StateObject private var registrationViewModel = RegistrationViewModel()
    @StateObject private var forgotPasswordViewModel = ForgoًtPasswordViewModel()

    private let repository: AuthRepositoryProtocol = AuthRepositoryFactory.make()

    var body: some View {
        Group {
            if !sessionChecked {
                // Splash-like blank while we do the synchronous session check
                Color(.systemBackground).ignoresSafeArea()
            } else {
                screenContent
            }
        }
        .task {
            // MARK: Cold-launch session restore
            // Run once on appear — reads persisted session from UserDefaults.
            // If valid (token non-empty AND not expired), skip the auth flow.
            if let session = repository.currentSession(), session.isValid {
                appScreen = .home
            }
            sessionChecked = true
        }
    }


    @ViewBuilder
    private var screenContent: some View {
        switch appScreen {

        case .login:
            LoginView(
                viewModel: loginViewModel,
                onNavigateToSignUp: {
                    appScreen = .registration
                },
                onLoginSuccess: { _ in
                    appScreen = .home
                },
                onForgotPassword: {
                    appScreen = .forgotPassword
                },
                onContinueAsGuest: {
                    appScreen = .home
                }
            )
            .onReceive(loginViewModel.$pendingSocialUser.compactMap { $0 }) { result in
                if case .newUser(let email, let displayName, _) = result {
                    appScreen = .setPassword(email: email, displayName: displayName)
                }
            }
            .onReceive(loginViewModel.$completedSession.compactMap { $0 }) { _ in
                appScreen = .home
            }

        case .registration:
            RegistrationView(
                viewModel: registrationViewModel,
                onNavigateToLogin: {
                    appScreen = .login
                },
                onContinueAsGuest: { _ in
                    appScreen = .home
                },
                onRegistrationSuccess: { _ in
                    appScreen = .home
                }
            )
            .onReceive(registrationViewModel.$pendingSocialUser.compactMap { $0 }) { result in
                if case .newUser(let email, let displayName, _) = result {
                    appScreen = .setPassword(email: email, displayName: displayName)
                }
            }

        case .forgotPassword:
            ForgotPasswordView(
                viewModel: forgotPasswordViewModel,
                onNavigateBack: {
                    appScreen = .login
                }
            )

        case .setPassword(let email, let displayName):
            let vm = SetPasswordViewModel(email: email, displayName: displayName)
            SetPasswordView(viewModel: vm)
                .onReceive(vm.$completedSession.compactMap { $0 }) { _ in
                    appScreen = .home
                }

        case .home:
            HomeView(viewModel: HomeViewModel(repository: HomeRepository(networkClient: URLSessionNetworkClient())))
        }
    }
}


#Preview {
    ContentView()
}
