//
//  ContentView.swift
//  Shopify
//
//  Created by Ahmed Elkady on 27/06/2026.
//

import SwiftUI
import Auth

struct ContentView: View {
    @State private var authScreen: AuthScreen = .login

    var body: some View {
        let repo = AuthRepositoryFactory.make()
        let googleUseCase = GoogleSignInUseCase(repository: repo)

        switch authScreen {
        case .login:
            let loginViewModel = LoginViewModel(
                loginUseCase: LoginUseCase(repository: repo),
                googleSignInUseCase: googleUseCase
            )

            LoginView(
                viewModel: loginViewModel,
                onNavigateToSignUp: {
                    authScreen = .registration
                },
                onLoginSuccess: {}
            )

        case .registration:
            let registrationViewModel = RegistrationViewModel(
                registerUseCase: RegisterUseCase(repository: repo),
                googleSignInUseCase: googleUseCase,
                continueAsGuestUseCase: ContinueAsGuestUseCase()
            )

            RegistrationView(
                viewModel: registrationViewModel,
                onNavigateToLogin: {
                    authScreen = .login
                },
                onContinueAsGuest: { _ in }
            )
        }
    }
}

private enum AuthScreen {
    case login
    case registration
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
