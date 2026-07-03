//
//  ForgotPasswordView.swift
//  Auth
//
//  Created by Agent on 02/07/2026.
//
import SwiftUI
import Common

public struct ForgotPasswordView: View {

    @ObservedObject var viewModel: ForgotPasswordViewModel
    @Environment(AuthCoordinator.self) private var coordinator

    public init(viewModel: ForgotPasswordViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                // MARK: - Header
                ZStack {
                    Text("Reset Password")
                        .font(.system(size: 23, weight: .bold))
                        .foregroundColor(.primary)

                    HStack {
                        Button(action: { coordinator.pop() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.primary)
                        }
                        Spacer()
                    }
                }
                .padding(.top, 18)

                if viewModel.isEmailSent {
                    successView
                } else {
                    formView
                }
            }
            .padding(.horizontal, 20)
        }
        .background(Color(.systemBackground))
        .animation(.easeInOut(duration: 0.3), value: viewModel.isEmailSent)
        .navigationBarHidden(true)
    }

    // MARK: - Form View
    private var formView: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text("Forgot your password?")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)

                Text("Enter the email associated with your account and we'll send you a reset link.")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
            }

            CustomInputField(
                title: "Email",
                placeholder: "example@email.com",
                text: $viewModel.email
            )
            .keyboardType(.emailAddress)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)

            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.callout)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, minHeight: 58)
            } else {
                PrimaryButton(title: "Send Reset Link", icon: "envelope") {
                    viewModel.sendResetEmail()
                }
                .opacity(viewModel.isFormValid ? 1.0 : 0.6)
                .disabled(!viewModel.isFormValid)
            }
        }
    }

    // MARK: - Success View
    private var successView: some View {
        VStack(spacing: 24) {
            Spacer().frame(height: 20)

            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.12))
                    .frame(width: 100, height: 100)

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 52))
                    .foregroundColor(.green)
            }

            VStack(spacing: 10) {
                Text("Check your inbox!")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.primary)

                Text("A reset link has been sent to\n\(viewModel.email)")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            PrimaryButton(title: "Back to Sign In", icon: "arrow.left") {
                coordinator.pop()
            }
            .padding(.top, 8)
        }
    }
}
