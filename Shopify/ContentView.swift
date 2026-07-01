//
//  ContentView.swift
//  Shopify
//
//  Created by Ahmed Elkady on 27/06/2026.
//

import SwiftUI
import Auth

// MARK: - Auth Screen Enum

private enum AuthScreen: Equatable {
    case login
    case registration
    case forgotPassword
    case setPassword(email: String, displayName: String?)
}

// MARK: - ContentView

struct ContentView: View {

    @State private var currentScreen: AuthScreen = .login

    // ViewModels kept alive for the lifetime of the auth flow
    @StateObject private var loginViewModel = LoginViewModel()
    @StateObject private var registrationViewModel = RegistrationViewModel()
    @StateObject private var forgotPasswordViewModel = ForgotPasswordViewModel()

    var body: some View {
        Group {
            switch currentScreen {

            // MARK: Login
            case .login:
                LoginView(
                    viewModel: loginViewModel,
                    onNavigateToSignUp: {
                        currentScreen = .registration
                    },
                    onLoginSuccess: { session in
                        // TODO: navigate to home / tab bar after login
                        print("[Auth] Login success — token: \(session.customerAccessToken.prefix(12))…")
                    },
                    onForgotPassword: {
                        currentScreen = .forgotPassword
                    },
                    onContinueAsGuest: {
                        // TODO: navigate to home as guest
                    }
                )
                // Listen for social sign-in returning a newUser (needs SetPassword)
                .onReceive(loginViewModel.$pendingSocialUser.compactMap { $0 }) { result in
                    if case .newUser(let email, let displayName, _) = result {
                        currentScreen = .setPassword(email: email, displayName: displayName)
                    }
                }

            // MARK: Registration
            case .registration:
                RegistrationView(
                    viewModel: registrationViewModel,
                    onNavigateToLogin: {
                        currentScreen = .login
                    },
                    onContinueAsGuest: { _ in
                        // TODO: navigate to home as guest
                    },
                    onRegistrationSuccess: { session in
                        // TODO: navigate to home / tab bar after registration
                        print("[Auth] Registration success — token: \(session.customerAccessToken.prefix(12))…")
                    }
                )
                // Listen for social sign-in on registration screen returning a newUser
                .onReceive(registrationViewModel.$pendingSocialUser.compactMap { $0 }) { result in
                    if case .newUser(let email, let displayName, _) = result {
                        currentScreen = .setPassword(email: email, displayName: displayName)
                    }
                }

            // MARK: Forgot Password
            case .forgotPassword:
                ForgotPasswordView(
                    viewModel: forgotPasswordViewModel,
                    onNavigateBack: {
                        currentScreen = .login
                    }
                )

            // MARK: Set Password (social users)
            case .setPassword(let email, let displayName):
                let vm = SetPasswordViewModel(email: email, displayName: displayName)
                SetPasswordView(viewModel: vm)
                    .onReceive(vm.$completedSession.compactMap { $0 }) { session in
                        // TODO: navigate to home / tab bar after social account bridging
                        print("[Auth] SetPassword success — token: \(session.customerAccessToken.prefix(12))…")
                    }
            }
        }
        .animation(.easeInOut(duration: 0.25), value: currentScreen)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
