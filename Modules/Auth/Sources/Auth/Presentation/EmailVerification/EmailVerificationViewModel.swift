//
//  EmailVerificationViewModel.swift
//  Auth
//
//  Created by Kiro on 05/07/2026.
//

import Foundation
import Combine
import FirebaseAuth

@MainActor
public final class EmailVerificationViewModel: ObservableObject {
    @Published public var isCheckingVerification: Bool = false
    @Published public var isResendingEmail: Bool = false
    @Published public var errorMessage: String?
    @Published public var successMessage: String?
    @Published public var isEmailVerified: Bool = false
    
    private let email: String
    private let firstName: String
    private let lastName: String
    private let firebaseUID: String
    private let repository: AuthRepositoryProtocol
    private var verificationCheckTimer: Timer?
    
    public init(
        email: String,
        firstName: String,
        lastName: String,
        firebaseUID: String,
        repository: AuthRepositoryProtocol = AuthRepositoryFactory.make()
    ) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.firebaseUID = firebaseUID
        self.repository = repository
    }
    
    deinit {
        stopVerificationCheck()
    }
    
    // MARK: - Start Verification Check
    
    public func startVerificationCheck() {
        // Check immediately
        Task {
            await checkEmailVerificationStatus()
        }
        
        // Then check every 3 seconds
        verificationCheckTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                await self?.checkEmailVerificationStatus()
            }
        }
    }
    
    public func stopVerificationCheck() {
        verificationCheckTimer?.invalidate()
        verificationCheckTimer = nil
    }
    
    // MARK: - Check Verification Status
    
    private func checkEmailVerificationStatus() async {
        guard !isCheckingVerification else { return }
        
        isCheckingVerification = true
        errorMessage = nil
        
        do {
            // Reload Firebase user to get latest email verification status
            try await Auth.auth().currentUser?.reload()
            
            guard let currentUser = Auth.auth().currentUser else {
                errorMessage = "Session expired. Please try registering again."
                stopVerificationCheck()
                isCheckingVerification = false
                return
            }
            
            if currentUser.isEmailVerified {
                // Email is verified! Complete registration
                stopVerificationCheck()
                await completeRegistration()
            }
            
            isCheckingVerification = false
        } catch {
            errorMessage = "Failed to check verification status: \(error.localizedDescription)"
            isCheckingVerification = false
        }
    }
    
    // MARK: - Complete Registration
    
    private func completeRegistration() async {
        do {
            let result = await repository.completeRegistrationAfterVerification(
                email: email,
                firstName: firstName,
                lastName: lastName,
                firebaseUID: firebaseUID
            )
            
            switch result {
            case .success:
                isEmailVerified = true
                successMessage = "Account created successfully!"
            case .failure(let error):
                errorMessage = error.userFacingMessage
            }
        }
    }
    
    // MARK: - Resend Verification Email
    
    public func resendVerificationEmail() {
        guard !isResendingEmail else { return }
        
        Task {
            isResendingEmail = true
            errorMessage = nil
            successMessage = nil
            
            do {
                guard let currentUser = Auth.auth().currentUser else {
                    errorMessage = "Session expired. Please try registering again."
                    isResendingEmail = false
                    return
                }
                
                try await currentUser.sendEmailVerification()
                successMessage = "Verification email sent! Please check your inbox."
                
                // Clear success message after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                    self?.successMessage = nil
                }
                
                isResendingEmail = false
            } catch {
                errorMessage = "Failed to send email: \(error.localizedDescription)"
                isResendingEmail = false
            }
        }
    }
    
    // MARK: - Cancel Registration
    
    public func cancelRegistration() {
        stopVerificationCheck()
        
        // Delete the Firebase user since they didn't verify
        Task {
            try? await Auth.auth().currentUser?.delete()
        }
    }
}
