import DependencyInjection
import Swinject
import ShopifyNetwork

// MARK: - Home Assembly for Dependency Injection
public class HomeAssembly: DIAssembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        // Register Data Sources
        container.register(HomeRemoteDataSource.self) { resolver in
            let networkClient = resolver.resolve(NetworkClient.self)!
            return HomeRemoteDataSource(networkClient: networkClient)
        }
        
        // Register Repository
        container.register(HomeRepositoryProtocol.self) { resolver in
            HomeRepository(
                remoteDataSource: resolver.resolve(HomeRemoteDataSource.self)!
            )
        }
        
        // Register Use Cases
        container.register(FetchFeaturedProductsUseCase.self) { resolver in
            FetchFeaturedProductsUseCase(repository: resolver.resolve(HomeRepositoryProtocol.self)!)
        }
        
        container.register(FetchBannersUseCase.self) { resolver in
            FetchBannersUseCase(repository: resolver.resolve(HomeRepositoryProtocol.self)!)
        }
        
        // Register ViewModels
        container.register(HomeViewModel.self) { resolver in
            HomeViewModel(
                fetchFeaturedProductsUseCase: resolver.resolve(FetchFeaturedProductsUseCase.self)!,
                fetchBannersUseCase: resolver.resolve(FetchBannersUseCase.self)!
            )
        }
    }
}
