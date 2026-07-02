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
    var onRegistrationSuccess: (Session) -> Void

    public init(
        viewModel: RegistrationViewModel,
        onNavigateToLogin: @escaping () -> Void,
        onContinueAsGuest: @escaping (UserSession) -> Void = { _ in },
        onRegistrationSuccess: @escaping (Session) -> Void = { _ in }
    ) {
        self.viewModel = viewModel
        self.onNavigateToLogin = onNavigateToLogin
        self.onContinueAsGuest = onContinueAsGuest
        self.onRegistrationSuccess = onRegistrationSuccess
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                ZStack {
                    Text("Create Account")
                        .font(.system(size: 23, weight: .bold))
                        .foregroundColor(.black)

                    HStack {
                        Button(action: onNavigateToLogin) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 28, weight: .medium))
                                .foregroundColor(.black)
                        }

                        Spacer()
                    }
                }
                .padding(.top, 18)

                VStack(spacing: 16) {
                    CustomInputField(title: "Full Name", placeholder: "Enter your name", text: $viewModel.fullName)

                    VStack(alignment: .leading, spacing: 8) {
                        CustomInputField(title: "Email", placeholder: "example@email.com", text: $viewModel.email)
                        Text("Verify email will be sent")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(.systemGray3))
                        if let error = viewModel.emailValidationError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        CustomInputField(title: "Password", placeholder: "Password", text: $viewModel.password, isSecure: true)
                        if let error = viewModel.passwordLengthError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        CustomInputField(title: "Confirm Password", placeholder: "Confirm password", text: $viewModel.confirmPassword, isSecure: true)
                        if let error = viewModel.passwordMatchError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.callout)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }

                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 58)
                } else {
                    PrimaryButton(title: "Sign Up") {
                        viewModel.register()
                    }
                    .opacity(viewModel.isFormValid ? 1.0 : 0.6)
                    .disabled(!viewModel.isFormValid)
                }

                SocialLoginRow(
                    label: "or sign up with",
                    onGoogleTap: { viewModel.signInWithGoogle() },
                    onAppleTap: {},
                    onFacebookTap: {}
                )
                .padding(.top, 10)

                Button(action: onNavigateToLogin) {
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .font(.system(size: 16))
                            .foregroundColor(Color(.darkGray))
                        Text("Login")
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 233 / 255.0, green: 69 / 255.0, blue: 96 / 255.0))
                    }
                }
                .padding(.top, 28)
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 18)
        }
        .background(Color(.systemBackground))
        .onReceive(viewModel.$completedSession.compactMap { $0 }) { session in
            onRegistrationSuccess(session)
        }
    }
}
