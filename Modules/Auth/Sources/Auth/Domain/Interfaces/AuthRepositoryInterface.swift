//
//  File.swift
//  
//
//  Created by Ahmed Elkady on 27/06/2026.
//

import Foundation
@available(iOS 13.0.0, *)
public protocol AuthRepositoryInterface {
    func login(email: String, password: String) async throws -> AuthUser
    func register(email: String, password: String, name: String) async throws -> AuthUser
    func signInWithGoogle() async throws -> AuthUser
    func signOut() throws
    func sendVerificationEmail() async throws
    var currentUser: AuthUser? { get }
}
