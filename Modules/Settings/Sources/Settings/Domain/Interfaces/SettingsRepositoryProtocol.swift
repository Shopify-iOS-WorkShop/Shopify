//
//  SettingsRepositoryProtocol.swift
//  Settings — Domain
//

import Foundation

public protocol SettingsRepositoryProtocol {
    func getCustomerProfile(customerAccessToken: String) async -> Result<CustomerProfile, SettingsError>
    func getExchangeRates(base: String) async -> Result<ExchangeRates, SettingsError>
}
