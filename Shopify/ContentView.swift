//
//  ContentView.swift
//  Shopify
//
//  Created by Ahmed Elkady on 27/06/2026.
//

import SwiftUI
import Auth

struct ContentView: View {
    var body: some View {
        let repo = AuthRepositoryFactory.make()
        let loginUseCase = LoginUseCase(repository: repo)
        let googleUseCase = GoogleSignInUseCase(repository: repo)
        
        let loginViewModel = LoginViewModel(
            loginUseCase: loginUseCase,
            googleSignInUseCase: googleUseCase,
        )
        
        LoginView(
            viewModel: loginViewModel,
            onNavigateToSignUp: {},
            onLoginSuccess: {}
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
