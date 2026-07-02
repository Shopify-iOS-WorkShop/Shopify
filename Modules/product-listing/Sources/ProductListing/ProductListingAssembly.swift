import DependencyInjection
import Swinject
import ShopifyNetwork

// MARK: - ProductListing Assembly for Dependency Injection
public class ProductListingAssembly: DIAssembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        // Register Data Sources
        container.register(ProductListingRemoteDataSource.self) { resolver in
            let networkClient = resolver.resolve(NetworkClient.self)!
            return ProductListingRemoteDataSource(networkClient: networkClient)
        }
        
        // Register Repository
        container.register(ProductListingRepositoryProtocol.self) { resolver in
            ProductListingRepository(
                remoteDataSource: resolver.resolve(ProductListingRemoteDataSource.self)!
            )
        }
        
        // Register Use Cases
        container.register(FilterProductsUseCase.self) { resolver in
            FilterProductsUseCase(repository: resolver.resolve(ProductListingRepositoryProtocol.self)!)
        }
        
        // Register ViewModels
        container.register(ProductListingViewModel.self) { resolver in
            ProductListingViewModel(
                filterProductsUseCase: resolver.resolve(FilterProductsUseCase.self)!
            )
        }
    }
}
