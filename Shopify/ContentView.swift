//
//  ContentView.swift
//  Shopify
//
//  Created by Ahmed Elkady on 27/06/2026.
//

import SwiftUI
import Auth

// MARK: - Auth Screen Enum

private enum AuthScreen {
    case login
    case registration
}

// MARK: - ContentView

struct ContentView: View {

    @State private var currentScreen: AuthScreen = .login

    // ViewModels created once and kept alive by ContentView
    @StateObject private var loginViewModel = LoginViewModel()
    @StateObject private var registrationViewModel = RegistrationViewModel()

    var body: some View {
        Group {
            switch currentScreen {
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
                        // TODO: push ForgotPasswordView
                    },
                    onContinueAsGuest: {
                        // TODO: navigate to home as guest
                    }
                )

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
            }
        }
        .animation(.easeInOut(duration: 0.25), value: currentScreen)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
