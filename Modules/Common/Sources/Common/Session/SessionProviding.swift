//
//  SessionProviding.swift
//  Common
//
//  Protocol for accessing current session state across modules
//

import Foundation

public protocol SessionProviding: AnyObject {
    var current: Session? { get }
    var isAuthenticated: Bool { get }
}

public extension SessionProviding {
    var isAuthenticated: Bool {
        guard let session = current else { return false }
        return !session.isExpired
    }
}
