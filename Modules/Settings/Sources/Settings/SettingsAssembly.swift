//
//  SettingsAssembly.swift
//  Settings
//

import DependencyInjection
import Swinject
import Common
import ShopifyNetwork

public class SettingsAssembly: DIAssembly {

    public init() {}

    public func assemble(container: Container) {

        // MARK: - Data Sources

        container.register(SettingsRemoteDataSource.self) { _ in
            SettingsRemoteDataSource()
        }

        container.register(ExchangeRateDataSource.self) { _ in
            ExchangeRateDataSource()
        }

        // MARK: - Repository

        container.register(SettingsRepositoryProtocol.self) { resolver in
            SettingsRepository(
                remoteDataSource: resolver.resolve(SettingsRemoteDataSource.self)!,
                exchangeRateDataSource: resolver.resolve(ExchangeRateDataSource.self)!
            )
        }.inObjectScope(.container)

        // MARK: - Use Cases

        container.register(GetCustomerProfileUseCase.self) { resolver in
            GetCustomerProfileUseCase(
                repository: resolver.resolve(SettingsRepositoryProtocol.self)!,
                sessionStore: resolver.resolve(SessionProviding.self)!
            )
        }

        container.register(GetExchangeRatesUseCase.self) { resolver in
            GetExchangeRatesUseCase(
                repository: resolver.resolve(SettingsRepositoryProtocol.self)!
            )
        }

        // MARK: - ViewModel

        container.register(SettingsViewModel.self) { resolver in
            SettingsViewModel(
                getProfileUseCase: resolver.resolve(GetCustomerProfileUseCase.self)!,
                getExchangeRatesUseCase: resolver.resolve(GetExchangeRatesUseCase.self)!,
                sessionStore: resolver.resolve(SessionProviding.self)!,  // required for isGuest
                currencyStore: resolver.resolve(CurrencyStore.self)!     // shared currency state
            )
        }
    }
}
