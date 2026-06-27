//
//  File.swift
//  
//
//  Created by Ahmed Elkady on 27/06/2026.
//

import Foundation

public enum UserSession: Equatable {

    case guest
    case authenticated(AuthUser)

    public var isAuthenticated: Bool {
        if case .authenticated = self { return true }
        return false
    }

    public var isGuest: Bool {
        self == .guest
    }

    public var user: AuthUser? {
        if case .authenticated(let user) = self { return user }
        return nil
    }
}
