//
//  File.swift
//  
//
//  Created by Ahmed Elkady on 27/06/2026.
//

import Foundation

public protocol AuthRepositoryProtocol {
    func signUp(email: String, password: String, firstName: String, lastName: String) async -> Result<Session, AuthError>
    func signIn(email: String, password: String) async -> Result<Session, AuthError>
    func signInWithSocial(provider: AuthProvider) async -> Result<SocialSignInResult, AuthError>
    func signOut() async -> Result<Void, AuthError>
    func recoverPassword(email: String) async -> Result<Void, AuthError>
    func currentSession() -> Session?
}
