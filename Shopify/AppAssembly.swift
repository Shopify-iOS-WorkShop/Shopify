//
//  AppAssembly.swift
//  Shopify
//
//  Created by AI Assistant
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
import Favorites

class AppAssembly {
    static let shared = AppAssembly()
    
    let container: Container
    private var isSetup = false
    
    private init() {
        container = DIContainer.shared.getContainer()
    }
    
    func setup(with modelContext: ModelContext) -> AppAssembly {
        guard !isSetup else { return self }
        
        // Register ModelContext first (required by DataPersistence)
        container.register(ModelContext.self) { _ in modelContext }
            .inObjectScope(.container)
        
        assembleModules()
        isSetup = true
        return self
    }
    
    private func assembleModules() {
        // Order matters: dependencies must be registered first
        ShopifyNetworkAssembly().assemble(container: container)
        CommonAssembly().assemble(container: container)
        DataPersistenceAssembly().assemble(container: container)
        
        AuthAssembly().assemble(container: container)
        CartAssembly().assemble(container: container)
        HomeAssembly().assemble(container: container)
        ProductDetailsAssembly().assemble(container: container)
        ProductListingAssembly().assemble(container: container)
        FavoritesAssembly().assemble(container: container)
    }
    
    
    func resolve<T>(_ type: T.Type) -> T {
        guard let resolved = container.resolve(type) else {
            fatalError("Could not resolve type \(type)")
        }
        return resolved
    }
    
    func resolveOptional<T>(_ type: T.Type) -> T? {
        return container.resolve(type)
    }

    @MainActor
    func makeFavoritesViewModel() -> FavoritesViewModel {
        FavoritesFactory.makeViewModel(container: container)
    }
}
