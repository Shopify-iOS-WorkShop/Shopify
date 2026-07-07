//
//  ResetPasswordViewModel.swift
//  Auth
//
//  Created by Kiro on 05/07/2026.
//

import Foundation
import Combine
import FirebaseAuth

@MainActor
public final class ResetPasswordViewModel: ObservableObject {
    @Published public var newPassword: String = ""
    @Published public var confirmPassword: String = ""
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    @Published public var successMessage: String?
    @Published public var isPasswordReset: Bool = false
    
    public let email: String // Read-only email from the reset link
    private let oobCode: String // Firebase out-of-band code from reset link
    
    public init(email: String, oobCode: String) {
        self.email = email
        self.oobCode = oobCode
    }
    
    // MARK: - Validation
    
    public var isFormValid: Bool {
        !newPassword.isEmpty &&
        newPassword.count >= 8 &&
        newPassword == confirmPassword
    }
    
    public var passwordLengthError: String? {
        guard !newPassword.isEmpty else { return nil }
        return newPassword.count >= 8 ? nil : "Password must be at least 8 characters"
    }
    
    public var passwordMatchError: String? {
        guard !confirmPassword.isEmpty else { return nil }
        return newPassword == confirmPassword ? nil : "Passwords do not match"
    }
    
    // MARK: - Reset Password Action
    
    public func resetPassword() {
        guard isFormValid else {
            errorMessage = "Please enter a valid password"
            return
        }
        
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        Task {
            do {
                // Verify the reset code first
                try await Auth.auth().verifyPasswordResetCode(oobCode)
                
                // Confirm the password reset
                try await Auth.auth().confirmPasswordReset(
                    withCode: oobCode,
                    newPassword: newPassword
                )
                
                isLoading = false
                isPasswordReset = true
                successMessage = "Password reset successfully! You can now sign in."
            } catch {
                isLoading = false
                errorMessage = "Failed to reset password: \(error.localizedDescription)"
            }
        }
    }
}
