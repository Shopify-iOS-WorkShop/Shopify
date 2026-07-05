//
//  Money.swift
//  Common
//
//  Represents a monetary amount with currency
//

import Foundation

/// Represents a monetary value with a specific currency
public struct Money: Equatable, Sendable, Codable {
    public let amount: Decimal
    public let currencyCode: String
    
    public init(amount: Decimal, currencyCode: String) {
        self.amount = amount
        self.currencyCode = currencyCode
    }
    
    /// Convenience initializer from string amount (for GraphQL responses)
    public init(amountString: String, currencyCode: String) {
        self.amount = Decimal(string: amountString) ?? 0
        self.currencyCode = currencyCode
    }
    
    /// Zero money for a given currency
    public static func zero(currencyCode: String = "USD") -> Money {
        return Money(amount: 0, currencyCode: currencyCode)
    }
    
    /// Formatted string representation (e.g., "USD 29.99")
    public var formatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        if let formattedString = formatter.string(from: amount as NSDecimalNumber) {
            return formattedString
        }
        
        // Fallback
        return "\(currencyCode) \(amount)"
    }
}

// MARK: - Comparable
extension Money: Comparable {
    public static func < (lhs: Money, rhs: Money) -> Bool {
        guard lhs.currencyCode == rhs.currencyCode else {
            // Can't compare different currencies directly
            return false
        }
        return lhs.amount < rhs.amount
    }
}

// MARK: - Arithmetic Operations
extension Money {
    public static func + (lhs: Money, rhs: Money) -> Money {
        guard lhs.currencyCode == rhs.currencyCode else {
            fatalError("Cannot add money with different currencies: \(lhs.currencyCode) and \(rhs.currencyCode)")
        }
        return Money(amount: lhs.amount + rhs.amount, currencyCode: lhs.currencyCode)
    }
    
    public static func - (lhs: Money, rhs: Money) -> Money {
        guard lhs.currencyCode == rhs.currencyCode else {
            fatalError("Cannot subtract money with different currencies: \(lhs.currencyCode) and \(rhs.currencyCode)")
        }
        return Money(amount: lhs.amount - rhs.amount, currencyCode: lhs.currencyCode)
    }
    
    public static func * (money: Money, multiplier: Decimal) -> Money {
        return Money(amount: money.amount * multiplier, currencyCode: money.currencyCode)
    }
    
    public static func * (money: Money, multiplier: Int) -> Money {
        return Money(amount: money.amount * Decimal(multiplier), currencyCode: money.currencyCode)
    }
}
