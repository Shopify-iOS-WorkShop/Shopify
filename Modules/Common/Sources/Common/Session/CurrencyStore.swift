//


import Foundation
import Observation


@Observable
public final class CurrencyStore {

   
    public var selectedCurrency: String {
        didSet {
            UserDefaults.standard.set(selectedCurrency, forKey: Self.currencyKey)
        }
    }

   
    public var exchangeRates: ExchangeRates?


    public init() {
        self.selectedCurrency = UserDefaults.standard.string(forKey: Self.currencyKey) ?? "USD"
    }

    
    public func convert(_ amount: Double) -> String {
        guard
            let rates = exchangeRates,
            let converted = rates.convert(amount, to: selectedCurrency)
        else {
            return "\(selectedCurrency) \(String(format: "%.2f", amount))"
        }
        return "\(selectedCurrency) \(String(format: "%.2f", converted))"
    }

    public func convert(_ amount: Decimal) -> String {
        return convert(NSDecimalNumber(decimal: amount).doubleValue)
    }


    private static let currencyKey = "settings_selectedCurrency"
}
