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

// MARK: - App Screen

private enum AppScreen: Equatable {
    // Auth flow screens
    case login
    case registration
    case forgotPassword
    case setPassword(email: String, displayName: String?)
    // Post-auth
    case home
}

// MARK: - ContentView

struct ContentView: View {

    // Start with login; session check on appear will promote to .home if valid
    @State private var appScreen: AppScreen = .login
    @State private var sessionChecked: Bool = false

    // Auth ViewModels kept alive for the lifetime of the auth flow
    @StateObject private var loginViewModel       = LoginViewModel()
    @StateObject private var registrationViewModel = RegistrationViewModel()
    @StateObject private var forgotPasswordViewModel = ForgotPasswordViewModel()

    // MARK: - Repository for cold-launch session check
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

    // MARK: - Screen Router

    @ViewBuilder
    private var screenContent: some View {
        switch appScreen {

        // MARK: Login
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
            // Social sign-in → new user path
            .onReceive(loginViewModel.$pendingSocialUser.compactMap { $0 }) { result in
                if case .newUser(let email, let displayName, _) = result {
                    appScreen = .setPassword(email: email, displayName: displayName)
                }
            }
            // Social sign-in → existing user path (already sets completedSession)
            .onReceive(loginViewModel.$completedSession.compactMap { $0 }) { _ in
                appScreen = .home
            }

        // MARK: Registration
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
            // Social sign-in from registration screen → new user
            .onReceive(registrationViewModel.$pendingSocialUser.compactMap { $0 }) { result in
                if case .newUser(let email, let displayName, _) = result {
                    appScreen = .setPassword(email: email, displayName: displayName)
                }
            }

        // MARK: Forgot Password
        case .forgotPassword:
            ForgotPasswordView(
                viewModel: forgotPasswordViewModel,
                onNavigateBack: {
                    appScreen = .login
                }
            )

        // MARK: Set Password (social users — account bridging)
        case .setPassword(let email, let displayName):
            let vm = SetPasswordViewModel(email: email, displayName: displayName)
            SetPasswordView(viewModel: vm)
                .onReceive(vm.$completedSession.compactMap { $0 }) { _ in
                    appScreen = .home
                }

        // MARK: Home
        case .home:
            HomeView(viewModel: HomeViewModel(repository: HomeRepository(networkClient: URLSessionNetworkClient())))
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
