//
//  SettingsRepository.swift
//  Settings — Data
//

import Foundation

final class SettingsRepository: SettingsRepositoryProtocol {
    private let remoteDataSource: SettingsRemoteDataSource
    private let exchangeRateDataSource: ExchangeRateDataSource

    init(
        remoteDataSource: SettingsRemoteDataSource,
        exchangeRateDataSource: ExchangeRateDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.exchangeRateDataSource = exchangeRateDataSource
    }

    func getCustomerProfile(customerAccessToken: String) async -> Result<CustomerProfile, SettingsError> {
        do {
            let profile = try await remoteDataSource.fetchCustomerProfile(
                customerAccessToken: customerAccessToken
            )
            return .success(profile)
        } catch let error as SettingsError {
            return .failure(error)
        } catch {
            return .failure(.networkError(error.localizedDescription))
        }
    }

    func getExchangeRates(base: String) async -> Result<ExchangeRates, SettingsError> {
        do {
            let rates = try await exchangeRateDataSource.fetchRates(base: base)
            return .success(rates)
        } catch let error as SettingsError {
            return .failure(error)
        } catch {
            return .failure(.networkError(error.localizedDescription))
        }
    }
}
