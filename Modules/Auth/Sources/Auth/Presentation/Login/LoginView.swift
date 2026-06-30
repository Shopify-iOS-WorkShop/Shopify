//
//  SwiftUIView.swift
//  Auth
//
//  Created by Al3dwy on 29/06/2026.
//

import SwiftUI
import Common

public struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    var onNavigateToSignUp: () -> Void
    var onLoginSuccess: () -> Void
    
    public init(
        viewModel: LoginViewModel,
        onNavigateToSignUp: @escaping () -> Void,
        onLoginSuccess: @escaping () -> Void = {}
    ) {
        self.viewModel = viewModel
        self.onNavigateToSignUp = onNavigateToSignUp
        self.onLoginSuccess = onLoginSuccess
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 96, height: 96)
                    
                    Text("Welcome Back")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                    Text("Log in to your PocketShop account")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
                .padding(.top, 40)
                
                VStack(spacing: 16) {
                    CustomInputField(title: "Email", placeholder: "Enter your email", text: $viewModel.email)
                    CustomInputField(title: "Password", placeholder: "********", text: $viewModel.password, isSecure: true)
                }
                
             
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.callout)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                VStack(spacing: 16) {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        PrimaryButton(title: "Login", icon: "arrow.right") {
                            viewModel.login()
                        }
                        .opacity(viewModel.isFormValid ? 1.0 : 0.6)
                        .disabled(!viewModel.isFormValid)
                    }
                }
                
                SocialLoginRow(label: "OR LOGIN WITH",
                               onGoogleTap: { viewModel.signInWithGoogle() },
                               onAppleTap: {},
                               onFacebookTap: {})
            }
            .padding()
            
            HStack(spacing: 4) {
                Text("Don't have an account?")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                Button(action: onNavigateToSignUp) {
                    Text("Sign Up")
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 233 / 255.0, green: 69 / 255.0, blue: 96 / 255.0))
                }
            }
            .padding(.bottom, 16)
            
            Button(action: {
            }) {
                Text("Continue as Guest")
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
                    .underline()
            }
            .padding(.bottom, 32)
        }
        .alert(isPresented: $viewModel.loginSucceeded) {
            Alert(
                title: Text("Success"),
                message: Text("You have logged in successfully."),
                dismissButton: .default(Text("OK"), action: onLoginSuccess)
            )
        }
    }
}
    
