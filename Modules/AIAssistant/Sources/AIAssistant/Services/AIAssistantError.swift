//
//  AIAssistantError.swift
//  AIAssistant
//
//  Created by Ahmed Elkady on 07/07/2026.
//

import Foundation

public enum AIAssistantError: LocalizedError {
    case shopifyError(String)
    case geminiError(String)
    case validationFailed([String])
    case noProductsFound
    case imageTooLarge
    case networkUnavailable
    case unknown(Error)

    public var errorDescription: String? {
        switch self {
        case .shopifyError(let m):   return "Shopify error: \(m)"
        case .geminiError(let m):    return "Gemini error: \(m)"
        case .validationFailed(let v): return "Validation: \(v.joined(separator: ", "))"
        case .noProductsFound:       return "No matching products found in the store."
        case .imageTooLarge:         return "Image is too large. Please use an image under 4 MB."
        case .networkUnavailable:    return "No internet connection."
        case .unknown(let e):        return "Unexpected error: \(e.localizedDescription)"
        }
    }
}
