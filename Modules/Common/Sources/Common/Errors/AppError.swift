//
//  AppError.swift
//  Common
//
//  Unified error type for the application
//

import Foundation


public enum AppError: Error, Equatable {
    case network(URLError)
    
    
    case graphQL([String])
    
    case authentication(String)
    
    case validation(String)
    
    case unknown
    
    public var userFacingMessage: String {
        switch self {
        case .network(let urlError):
            if urlError.code == .notConnectedToInternet {
                return "No internet connection. Please check your network."
            } else if urlError.code == .timedOut {
                return "Request timed out. Please try again."
            } else {
                return "Network error. Please try again later."
            }
            
        case .graphQL(let messages):
            return messages.first ?? "An error occurred. Please try again."
            
        case .authentication(let message):
            return message
            
        case .validation(let message):
            return message
            
        case .unknown:
            return "An unexpected error occurred. Please try again."
        }
    }
    
    public static func == (lhs: AppError, rhs: AppError) -> Bool {
        switch (lhs, rhs) {
        case (.network(let lhsError), .network(let rhsError)):
            return lhsError.code == rhsError.code
        case (.graphQL(let lhsMessages), .graphQL(let rhsMessages)):
            return lhsMessages == rhsMessages
        case (.authentication(let lhsMessage), .authentication(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (.validation(let lhsMessage), .validation(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (.unknown, .unknown):
            return true
        default:
            return false
        }
    }
}
