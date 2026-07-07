//
//  EmailVerificationView.swift
//  Auth
//
//  Created by Kiro on 05/07/2026.
//

import SwiftUI
#if canImport(Common)
import Common
#endif

@available(iOS 13.0.0, *)
public struct EmailVerificationView: View {
    @ObservedObject var viewModel: EmailVerificationViewModel
    @Environment(AuthCoordinator.self) private var coordinator
    
    public init(viewModel: EmailVerificationViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack(spacing: 32) {
            // Header with back button
            ZStack {
                Text("Verify Your Email")
                    .font(.system(size: 23, weight: .bold))
                    .foregroundColor(.black)
                
                HStack {
                    Button(action: {
                        viewModel.cancelRegistration()
                        coordinator.popToRoot()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
            }
            .padding(.top, 18)
            
            Spacer()
            
            // Email Icon
            Image(systemName: "envelope.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(Color(red: 233 / 255.0, green: 69 / 255.0, blue: 96 / 255.0))
            
            // Instruction Text
            VStack(spacing: 12) {
                Text("Check Your Email")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                
                Text("We've sent a verification link to:")
                    .font(.system(size: 16))
                    .foregroundColor(Color(.darkGray))
                    .multilineTextAlignment(.center)
                
                Text(viewModel.email)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                Text("Click the link in the email to verify your account and continue.")
                    .font(.system(size: 14))
                    .foregroundColor(Color(.darkGray))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.top, 8)
            }
            
            // Verification Status
            if viewModel.isCheckingVerification {
                HStack(spacing: 12) {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Checking verification status...")
                        .font(.system(size: 14))
                        .foregroundColor(Color(.darkGray))
                }
                .padding()
            }
            
            // Messages
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.callout)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            if let success = viewModel.successMessage {
                Text(success)
                    .font(.callout)
                    .foregroundColor(.green)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            
            // Resend Button
            VStack(spacing: 16) {
                if viewModel.isResendingEmail {
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 58)
                } else {
                    Button(action: {
                        viewModel.resendVerificationEmail()
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Resend Verification Email")
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(red: 233 / 255.0, green: 69 / 255.0, blue: 96 / 255.0))
                        .frame(maxWidth: .infinity, minHeight: 58)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
                
                // Cancel Button
                Button(action: {
                    viewModel.cancelRegistration()
                    coordinator.popToRoot()
                }) {
                    Text("Cancel Registration")
                        .font(.system(size: 16))
                        .foregroundColor(Color(.darkGray))
                }
                .padding(.bottom, 24)
            }
        }
        .padding(.horizontal, 18)
        .background(Color(.systemBackground))
        .navigationBarHidden(true)
        .onAppear {
            viewModel.startVerificationCheck()
        }
        .onDisappear {
            viewModel.stopVerificationCheck()
        }
        .onChange(of: viewModel.isEmailVerified) { _, isVerified in
            if isVerified {
                // Navigate to home after successful verification
                coordinator.onLoginSuccess?()
            }
        }
    }
}
