//
//  SettingsError.swift
//  Settings — Domain
//

import Foundation

public enum SettingsError: Error, LocalizedError {
    case notAuthenticated
    case networkError(String)
    case decodingError
    case unknown

    public var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "You must be signed in to view your profile."
        case .networkError(let message):
            return message
        case .decodingError:
            return "Failed to read server response."
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}
