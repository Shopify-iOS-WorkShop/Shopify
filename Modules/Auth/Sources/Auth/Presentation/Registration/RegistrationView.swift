//
//  RegistrationView.swift
//  Auth
//
//  Created by Ahmed Elkady on 28/06/2026.
//

import SwiftUI
#if canImport(Common)
import Common
#endif

@available(iOS 13.0.0, *)
public struct RegistrationView: View {
    @ObservedObject var viewModel: RegistrationViewModel
    var onNavigateToLogin: () -> Void
    var onContinueAsGuest: (UserSession) -> Void

    public init(
        viewModel: RegistrationViewModel,
        onNavigateToLogin: @escaping () -> Void,
        onContinueAsGuest: @escaping (UserSession) -> Void = { _ in }
    ) {
        self.viewModel = viewModel
        self.onNavigateToLogin = onNavigateToLogin
        self.onContinueAsGuest = onContinueAsGuest
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Logo placeholder or text
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)

                VStack(spacing: 16) {
                    // First Name & Last Name
                    HStack(spacing: 16) {
                        CustomInputField(title: "First Name", placeholder: "John", text: $viewModel.firstName, isSecure: false)
                        CustomInputField(title: "Last Name", placeholder: "Doe", text: $viewModel.lastName, isSecure: false)
                    }

                    // Email
                    CustomInputField(title: "Email", placeholder: "john.doe@example.com", text: $viewModel.email, isSecure: false)

                    // Password
                    VStack(alignment: .leading, spacing: 4) {
                        CustomInputField(title: "Password", placeholder: "Enter password", text: $viewModel.password, isSecure: true)
                        if let error = viewModel.passwordLengthError {
                            Text(error).font(.caption).foregroundColor(.red)
                        }
                    }

                    // Confirm Password
                    VStack(alignment: .leading, spacing: 4) {
                        CustomInputField(title: "Confirm Password", placeholder: "Re-enter password", text: $viewModel.confirmPassword, isSecure: true)
                        if let error = viewModel.passwordMatchError {
                            Text(error).font(.caption).foregroundColor(.red)
                        }
                    }
                }
                .padding(.horizontal)

                // Error Message
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.callout)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                // Register Button
                VStack(spacing: 16) {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        PrimaryButton(title: "Sign Up", icon: nil) {
                            viewModel.register()
                        }
                        .opacity(viewModel.isFormValid ? 1.0 : 0.6)
                        .disabled(!viewModel.isFormValid)
                    }

                    // Social Login
                    SocialLoginRow(
                        label: "Or Sign Up with",
                        onGoogleTap: { viewModel.signInWithGoogle() },
                        onAppleTap: { /* Future Apple Sign In */ },
                        onFacebookTap: { /* Future Facebook Sign In */ }
                    )
                    .padding(.top, 16)
                }
                .padding(.horizontal)

                Spacer(minLength: 32)

                // Sign In Link
                Button(action: onNavigateToLogin) {
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .foregroundColor(.gray)
                        Text("Sign In")
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 233 / 255.0, green: 69 / 255.0, blue: 96 / 255.0)) // Onboarding theme color
                    }
                }
                .padding(.bottom, 16)
                
                // Guest Mode Link
                Button(action: {
                    onContinueAsGuest(viewModel.continueAsGuest())
                }) {
                    Text("Continue as Guest")
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                        .underline()
                }
                .padding(.bottom, 32)
            }
        }
        .alert(isPresented: $viewModel.registrationSucceeded) {
            Alert(
                title: Text("Success"),
                message: Text("Your account has been created successfully."),
                dismissButton: .default(Text("OK"), action: onNavigateToLogin)
            )
        }
    }
}
