//
//  AppAssembly.swift
//  Shopify
//

import Foundation
import SwiftData
import DependencyInjection
import Swinject
import Auth
import Cart
import Common
import DataPersistence
import Home
import ProductDetails
import ProductListing
import ShopifyNetwork
import Settings
import Favorites
import Addresss
import Payment
import search

class AppAssembly {
    static let shared = AppAssembly()

    let container: Container
    private var isSetup = false

    private init() {
        container = DIContainer.shared.getContainer()
    }

    func setup(with modelContext: ModelContext) -> AppAssembly {
        guard !isSetup else { return self }
        container.register(ModelContext.self) { _ in modelContext }
            .inObjectScope(.container)
        assembleModules()
        isSetup = true
        return self
    }

    private func assembleModules() {
        ShopifyNetworkAssembly().assemble(container: container)
        CommonAssembly().assemble(container: container)
        DataPersistenceAssembly().assemble(container: container)

        AuthAssembly().assemble(container: container)
        CartAssembly().assemble(container: container)
        HomeAssembly().assemble(container: container)
        ProductDetailsAssembly().assemble(container: container)
        ProductListingAssembly().assemble(container: container)
        SettingsAssembly().assemble(container: container)
        FavoritesAssembly().assemble(container: container)
        AddressAssembly().assemble(container: container)
        PaymentAssembly().assemble(container: container)
        SearchAssembly().assemble(container: container)

    }
    func resolve<T>(_ type: T.Type) -> T {
        guard let resolved = container.resolve(type) else {
            fatalError("Could not resolve type \(type)")
        }
        return resolved
    }

    func resolveOptional<T>(_ type: T.Type) -> T? {
        container.resolve(type)
    }

    @MainActor
    func makeFavoritesViewModel() -> FavoritesViewModel {
        FavoritesFactory.makeViewModel(container: container)
    }

    @MainActor
    func makeSearchViewModel() -> SearchViewModel {
        SearchFactory.makeViewModel(container: container)
    }
}
