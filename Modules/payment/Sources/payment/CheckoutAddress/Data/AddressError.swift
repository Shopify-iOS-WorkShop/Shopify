//
//  File.swift
//  
//
//  Created by Mazen Amr on 03/07/2026.
//

import Foundation

public enum AddressError: LocalizedError {
    case missingToken
    case apiError(String)
    
    public var errorDescription: String? {
        switch self {
        case .missingToken: return "Please log in to manage your addresses."
        case .apiError(let message): return message
        }
    }
}
