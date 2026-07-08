//
//  SetPasswordView.swift
//  Auth
//
//  Created by Agent on 02/07/2026.
//

import SwiftUI
import Common

public struct SetPasswordView: View {

    @ObservedObject var viewModel: SetPasswordViewModel
    @Environment(AuthCoordinator.self) private var coordinator

    public init(viewModel: SetPasswordViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 28) {

                // MARK: - Header
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        DS.red.opacity(0.15),
                                        DS.red.opacity(0.05)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)

                        Image(systemName: "lock.shield.fill")
                            .font(.system(size: 36))
                            .foregroundColor(DS.red)
                    }
                    .padding(.top, 32)

                    Text("Set a Password")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(DS.textPri)

                    VStack(spacing: 4) {
                        Text("To complete your account, set a password for")
                            .font(.system(size: 14))
                            .foregroundColor(DS.textSec)
                        Text(viewModel.email)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(DS.red)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                }

                // MARK: - Form Fields
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        CustomInputField(
                            title: "First Name",
                            placeholder: "First",
                            text: $viewModel.firstName
                        )
                        CustomInputField(
                            title: "Last Name",
                            placeholder: "Last",
                            text: $viewModel.lastName
                        )
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        CustomInputField(
                            title: "Password",
                            placeholder: "Choose a password",
                            text: $viewModel.password,
                            isSecure: true
                        )
                        if let err = viewModel.passwordLengthError {
                            Text(err)
                                .font(.caption)
                                .foregroundColor(DS.red)
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        CustomInputField(
                            title: "Confirm Password",
                            placeholder: "Repeat your password",
                            text: $viewModel.confirmPassword,
                            isSecure: true
                        )
                        if let err = viewModel.passwordMatchError {
                            Text(err)
                                .font(.caption)
                                .foregroundColor(DS.red)
                        }
                    }
                }

                // MARK: - Error Banner
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.callout)
                        .foregroundColor(DS.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                // MARK: - CTA
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 58)
                } else {
                    PrimaryButton(title: "Continue", icon: "arrow.right") {
                        viewModel.confirm()
                    }
                    .opacity(viewModel.isFormValid ? 1.0 : 0.6)
                    .disabled(!viewModel.isFormValid)
                }

                // MARK: - Disclaimer
                Text("This password will be used for your shopping account and is separate from your social login.")
                    .font(.caption)
                    .foregroundColor(DS.textSec)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 24)
            }
            .padding(.horizontal, 20)
        }
        .background(DS.background)
        .onReceive(viewModel.$completedSession.compactMap { $0 }) { session in
            coordinator.onLoginSuccess?()
        }
        .navigationBarHidden(true)
    }
}
