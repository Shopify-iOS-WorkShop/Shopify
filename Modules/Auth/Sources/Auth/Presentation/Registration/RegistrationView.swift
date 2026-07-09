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
    @Environment(AuthCoordinator.self) private var coordinator

    public init(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                ZStack {
                    Text("Create Account")
                        .font(.system(size: 23, weight: .bold))
                        .foregroundColor(DS.textPri)

                    HStack {
                        Button(action: { coordinator.pop() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 28, weight: .medium))
                                .foregroundColor(DS.textPri)
                        }
                        Spacer()
                    }
                }
                .padding(.top, 18)

                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        CustomInputField(title: "Full Name", placeholder: "Enter your name", text: $viewModel.fullName)
                        if let error = viewModel.nameValidationError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(DS.red)
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        CustomInputField(title: "Email", placeholder: "example@email.com", text: $viewModel.email)
                        Text("Verify email will be sent")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(DS.textSec.opacity(0.45))
                        if let error = viewModel.emailValidationError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(DS.red)
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        CustomInputField(title: "Password", placeholder: "Password", text: $viewModel.password, isSecure: true)
                        if let error = viewModel.passwordLengthError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(DS.red)
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        CustomInputField(title: "Confirm Password", placeholder: "Confirm password", text: $viewModel.confirmPassword, isSecure: true)
                        if let error = viewModel.passwordMatchError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(DS.red)
                        }
                    }
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

                Button(action: { coordinator.pop() }) {
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .font(.system(size: 16))
                            .foregroundColor(DS.textSec)
                        Text("Login")
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                            .foregroundColor(DS.red)
                    }
                }
                .padding(.top, 28)
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 18)
        }
        .background(DS.background)
        .onReceive(viewModel.$completedSession.compactMap { $0 }) { session in
            coordinator.onLoginSuccess?()
        }
        .onChange(of: viewModel.shouldNavigateToVerification) { _, shouldNavigate in
            if shouldNavigate {
                coordinator.push(.emailVerification(
                    email: viewModel.verificationEmail,
                    firstName: viewModel.verificationFirstName,
                    lastName: viewModel.verificationLastName,
                    firebaseUID: viewModel.verificationFirebaseUID
                ))
                viewModel.shouldNavigateToVerification = false
            }
        }
        .alert(isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { isPresented in
                if !isPresented {
                    viewModel.errorMessage = nil
                }
            }
        )) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? ""),
                dismissButton: .default(Text("OK"))
            )
        }
        .navigationBarHidden(true)
    }
}
