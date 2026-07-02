import DependencyInjection
import Swinject
import SwiftData
import ShopifyNetwork
import Common
import DataPersistence

// MARK: - Cart Assembly for Dependency Injection
public class CartAssembly: DIAssembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        // Register Data Sources
        container.register(CartRemoteDataSource.self) { resolver in
            let networkClient = resolver.resolve(NetworkClient.self)!
            let graphQLClient = GraphQLClient(networkClient: networkClient)
            return CartRemoteDataSource(client: graphQLClient)
        }
        
        container.register(CartLocalDataSource.self) { resolver in
            let modelContext = resolver.resolve(ModelContext.self)!
            let dbClient = SwiftDataClient(context: modelContext)
            return CartLocalDataSource(dbClient: dbClient)
        }
        
        // Register Repository
        container.register(CartRepositoryProtocol.self) { resolver in
            CartRepositoryImpl(
                remoteDataSource: resolver.resolve(CartRemoteDataSource.self)!,
                localDataSource: resolver.resolve(CartLocalDataSource.self)!,
                sessionStore: resolver.resolve(SessionProviding.self)!
            )
        }
        
        // Register Use Cases
        container.register(GetOrCreateCartUseCase.self) { resolver in
            GetOrCreateCartUseCase(repository: resolver.resolve(CartRepositoryProtocol.self)!)
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
        
        container.register(ObserveCartUseCase.self) { resolver in
            ObserveCartUseCase(repository: resolver.resolve(CartRepositoryProtocol.self)!)
        }
        
        container.register(ClearCartUseCase.self) { resolver in
            ClearCartUseCase(repository: resolver.resolve(CartRepositoryProtocol.self)!)
        }
        
        // Register ViewModels
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
        
        // Register Coordinator
        container.register(CartCoordinator.self) { _ in
            CartCoordinator()
        }
    }
}
