//
//  File.swift
//  
//
//  Created by Ahmed Elkady on 27/06/2026.
//

import Foundation
public struct AuthUser {
    public let uid: String
    public let email: String?
    public let displayName: String?
    public let photoURL: URL?
    public let isEmailVerified: Bool
    public let phoneNumber: String?
    public let providerID: String
    public let creationDate: Date?
    public let lastSignInDate: Date?

    public init(
        uid: String,
        email: String?,
        displayName: String?,
        photoURL: URL?,
        isEmailVerified: Bool,
        phoneNumber: String?,
        providerID: String,
        creationDate: Date?,
        lastSignInDate: Date?
    ) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
        self.isEmailVerified = isEmailVerified
        self.phoneNumber = phoneNumber
        self.providerID = providerID
        self.creationDate = creationDate
        self.lastSignInDate = lastSignInDate
    }
}
