//
//  CartAssembly.swift
//  Cart
//
//  Dependency Injection assembly for Cart module
//

import DependencyInjection
import Swinject
import Common
import ShopifyNetwork
import DataPersistence

// MARK: - Cart Assembly for Dependency Injection
public class CartAssembly: DIAssembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        // MARK: - Data Sources
        
        // Remote Data Source
        container.register(CartRemoteDataSourceProtocol.self) { resolver in
            let client = resolver.resolve(GraphQLClientProtocol.self)!
            return CartRemoteDataSource(client: client)
        }
        
        // Local Data Source
        container.register(CartLocalDataSourceProtocol.self) { resolver in
            let dbClient = resolver.resolve(LocalDatabaseClientProtocol.self)!
            return CartLocalDataSource(dbClient: dbClient)
        }
        
        // MARK: - Repository
        
        container.register(CartRepositoryProtocol.self) { resolver in
            CartRepositoryImpl(
                remoteDataSource: resolver.resolve(CartRemoteDataSourceProtocol.self)!,
                localDataSource: resolver.resolve(CartLocalDataSourceProtocol.self)!,
                sessionStore: resolver.resolve(SessionProviding.self)!
            )
        }.inObjectScope(.container)
        
        // MARK: - Use Cases
        
        container.register(GetOrCreateCartUseCase.self) { resolver in
            GetOrCreateCartUseCase(
                repository: resolver.resolve(CartRepositoryProtocol.self)!
            )
        }
        
        container.register(AddCartLineUseCase.self) { resolver in
            AddCartLineUseCase(repository: resolver.resolve(CartRepositoryProtocol.self)!)
        }
        
        container.register(UpdateCartLineQuantityUseCase.self) { resolver in
            UpdateCartLineQuantityUseCase(repository: resolver.resolve(CartRepositoryProtocol.self)!)
        }
        
        container.register(RemoveCartLineUseCase.self) { resolver in
            RemoveCartLineUseCase(repository: resolver.resolve(CartRepositoryProtocol.self)!)
        }
        
        container.register(ApplyDiscountCodeUseCase.self) { resolver in
            ApplyDiscountCodeUseCase(repository: resolver.resolve(CartRepositoryProtocol.self)!)
        }
        
        container.register(RemoveDiscountCodeUseCase.self) { resolver in
            RemoveDiscountCodeUseCase(repository: resolver.resolve(CartRepositoryProtocol.self)!)
        }
        
        container.register(AttachCustomerToCartUseCase.self) { resolver in
            AttachCustomerToCartUseCase(repository: resolver.resolve(CartRepositoryProtocol.self)!)
        }
        
        container.register(ObserveCartUseCase.self) { resolver in
            ObserveCartUseCase(repository: resolver.resolve(CartRepositoryProtocol.self)!)
        }
        
        container.register(ClearCartUseCase.self) { resolver in
            ClearCartUseCase(repository: resolver.resolve(CartRepositoryProtocol.self)!)
        }
        
        // MARK: - View Models
        
        container.register(CartViewModel.self) { resolver in
            CartViewModel(
                getOrCreateCartUseCase: resolver.resolve(GetOrCreateCartUseCase.self)!,
                addCartLineUseCase: resolver.resolve(AddCartLineUseCase.self)!,
                updateQuantityUseCase: resolver.resolve(UpdateCartLineQuantityUseCase.self)!,
                removeLineUseCase: resolver.resolve(RemoveCartLineUseCase.self)!,
                applyDiscountUseCase: resolver.resolve(ApplyDiscountCodeUseCase.self)!,
                removeDiscountUseCase: resolver.resolve(RemoveDiscountCodeUseCase.self)!,
                observeCartUseCase: resolver.resolve(ObserveCartUseCase.self)!,
                clearCartUseCase: resolver.resolve(ClearCartUseCase.self)!,
                sessionStore: resolver.resolve(SessionProviding.self)!
            )
        }
    }
}
