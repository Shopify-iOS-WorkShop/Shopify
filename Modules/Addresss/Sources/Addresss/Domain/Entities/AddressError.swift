//
//  AddressError.swift
//  Address
//
//  Created by Mina Nashaat on 05/07/2026.
//

import Foundation

public enum AddressError: Error, Equatable, LocalizedError {
    case missingToken

    case apiError(String)

    case network(String)

    case notFound

    case cannotDeleteDefault

    public var errorDescription: String? {
        switch self {
        case .missingToken:
            return "Please sign in again to manage your addresses."
        case .apiError(let message):
            return message
        case .network(let message):
            return message
        case .notFound:
            return "This address could not be found. It may have already been removed."
        case .cannotDeleteDefault:
            return "Your default address can't be deleted. Set another address as default first, then try again."
        }
    }
}
