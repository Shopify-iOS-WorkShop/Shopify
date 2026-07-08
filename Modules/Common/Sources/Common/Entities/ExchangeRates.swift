//
//  ExchangeRates.swift
//  Common
//
//  Moved here from the Settings module so that CurrencyStore (also in Common)
//  can reference it without creating a circular dependency.
//  Settings re-exports this type via a typealias in its own ExchangeRate.swift.
//

import Foundation

/// Holds live exchange rates relative to a base currency.
/// Used by CurrencyStore (Common) and SettingsViewModel (Settings).
public struct ExchangeRates: Equatable {
    public let baseCurrency: String
    public let rates: [String: Double]

    public init(baseCurrency: String, rates: [String: Double]) {
        self.baseCurrency = baseCurrency
        self.rates = rates
    }

    /// Converts an amount from the base currency to the target currency.
    public func convert(_ amount: Double, to targetCurrency: String) -> Double? {
        guard let rate = rates[targetCurrency] else { return nil }
        return amount * rate
    }

    /// All supported currency codes sorted alphabetically.
    public var availableCurrencies: [String] {
        rates.keys.sorted()
    }
}
