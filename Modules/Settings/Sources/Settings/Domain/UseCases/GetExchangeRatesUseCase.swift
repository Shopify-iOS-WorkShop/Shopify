//
//  GetExchangeRatesUseCase.swift
//  Settings — Domain
//

import Foundation

public final class GetExchangeRatesUseCase {
    private let repository: SettingsRepositoryProtocol

    public init(repository: SettingsRepositoryProtocol) {
        self.repository = repository
    }

    /// Fetches live exchange rates relative to the given base currency (default: EGP).
    public func execute(base: String = "USD") async -> Result<ExchangeRates, SettingsError> {
        return await repository.getExchangeRates(base: base)
    }
}
