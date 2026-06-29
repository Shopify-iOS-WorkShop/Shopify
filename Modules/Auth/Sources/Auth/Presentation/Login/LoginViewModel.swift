//
//  LoginViewModel.swift
//  Auth
//
//  Created by Al3dwy on 29/06/2026.
//

import Foundation
import Combine

public final class LoginViewModel: ObservableObject {

 
    @Published public var email: String    = ""
    @Published public var password: String = ""

    
    @Published public var isLoading: Bool          = false
    @Published public var errorMessage: String?    = nil
    @Published public var loginSucceeded: Bool     = false


 
    private let loginUseCase: LoginUseCase
    private let googleSignInUseCase: GoogleSignInUseCase
  

   
    public init(
        loginUseCase: LoginUseCase,
        googleSignInUseCase: GoogleSignInUseCase
    ) {
        self.loginUseCase = loginUseCase
        self.googleSignInUseCase = googleSignInUseCase
    }

   
    public var isFormValid: Bool {
        isValidEmail(email) && password.count >= 6
    }

   
    public func login() {
        guard validate() else { return }

        isLoading    = true
        errorMessage = nil

        Task { @MainActor in
            do {
                _ = try await loginUseCase.execute(
                    email: email.trimmingCharacters(in: .whitespaces),
                    password: password
                )

                isLoading = false
                loginSucceeded = true
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }
    
    
    public func signInWithGoogle() {
        isLoading = true
        errorMessage = nil
        
        Task { @MainActor in
            do {
                _ = try await googleSignInUseCase.execute()
                isLoading = false
                loginSucceeded = true
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }

   


    private func validate() -> Bool {
        if !isValidEmail(email) {
            errorMessage = "Please enter a valid email address."
            return false
        }
        if password.count < 6 {
            errorMessage = "Password must be at least 6 characters."
            return false
        }
        return true
    }

    private func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }
}
