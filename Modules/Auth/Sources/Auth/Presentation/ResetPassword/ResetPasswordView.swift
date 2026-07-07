//
//  ResetPasswordView.swift
//  Auth
//
//  Created by Kiro on 05/07/2026.
//

import SwiftUI
#if canImport(Common)
import Common
#endif

@available(iOS 13.0.0, *)
public struct ResetPasswordView: View {
    @ObservedObject var viewModel: ResetPasswordViewModel
    @Environment(AuthCoordinator.self) private var coordinator
    
    public init(viewModel: ResetPasswordViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                // Header
                ZStack {
                    Text("Reset Password")
                        .font(.system(size: 23, weight: .bold))
                        .foregroundColor(.black)
                    
                    HStack {
                        Button(action: { 
                            coordinator.path = NavigationPath() // Pop to root
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 28, weight: .medium))
                                .foregroundColor(.black)
                        }
                        Spacer()
                    }
                }
                .padding(.top, 18)
                
                if viewModel.isPasswordReset {
                    successView
                } else {
                    formView
                }
            }
            .padding(.horizontal, 18)
        }
        .background(Color(.systemBackground))
        .navigationBarHidden(true)
    }
    
    // MARK: - Form View
    
    private var formView: some View {
        VStack(spacing: 24) {
            // Email Display (read-only)
            VStack(alignment: .leading, spacing: 8) {
                Text("Resetting password for:")
                    .font(.system(size: 14))
                    .foregroundColor(Color(.darkGray))
                
                Text(viewModel.email)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
            }
            .padding(.top, 8)
            
            // New Password Field
            VStack(alignment: .leading, spacing: 4) {
                CustomInputField(
                    title: "New Password",
                    placeholder: "Enter new password",
                    text: $viewModel.newPassword,
                    isSecure: true
                )
                if let error = viewModel.passwordLengthError {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            
            // Confirm Password Field
            VStack(alignment: .leading, spacing: 4) {
                CustomInputField(
                    title: "Confirm Password",
                    placeholder: "Confirm new password",
                    text: $viewModel.confirmPassword,
                    isSecure: true
                )
                if let error = viewModel.passwordMatchError {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            
            // Error Message
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.callout)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
            
            // Reset Button
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, minHeight: 58)
            } else {
                PrimaryButton(title: "Reset Password") {
                    viewModel.resetPassword()
                }
                .opacity(viewModel.isFormValid ? 1.0 : 0.6)
                .disabled(!viewModel.isFormValid)
            }
            
            Spacer()
        }
    }
    
    // MARK: - Success View
    
    private var successView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Success Icon
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.12))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 52))
                    .foregroundColor(.green)
            }
            
            // Success Message
            VStack(spacing: 10) {
                Text("Password Reset!")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.black)
                
                Text("Your password has been reset successfully.\nYou can now sign in with your new password.")
                    .font(.system(size: 15))
                    .foregroundColor(Color(.darkGray))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
            
            PrimaryButton(title: "Back to Sign In") {
                coordinator.path = NavigationPath()
            }
            .padding(.bottom, 24)
        }
    }
}
