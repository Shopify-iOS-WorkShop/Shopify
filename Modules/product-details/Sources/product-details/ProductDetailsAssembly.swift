import DependencyInjection
import Swinject
import ShopifyNetwork

// MARK: - ProductDetails Assembly for Dependency Injection
public class ProductDetailsAssembly: DIAssembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        // Register Data Sources
        container.register(ProductDetailRemoteDataSource.self) { resolver in
            let networkClient = resolver.resolve(NetworkClient.self)!
            return ProductDetailRemoteDataSource(networkClient: networkClient)
        }
        
        // Register Repository
        container.register(ProductDetailRepositoryProtocol.self) { resolver in
            ProductDetailRepository(
                remoteDataSource: resolver.resolve(ProductDetailRemoteDataSource.self)!
            )
        }
        
        // Register Use Cases
        container.register(FetchProductDetailUseCase.self) { resolver in
            FetchProductDetailUseCase(repository: resolver.resolve(ProductDetailRepositoryProtocol.self)!)
        }
        
        container.register(FetchProductsUseCase.self) { resolver in
            FetchProductsUseCase(repository: resolver.resolve(ProductDetailRepositoryProtocol.self)!)
        }
        
        container.register(SearchProductsUseCase.self) { resolver in
            SearchProductsUseCase(repository: resolver.resolve(ProductDetailRepositoryProtocol.self)!)
        }
        
        // Register ViewModels
        container.register(ProductDetailViewModel.self) { (resolver, productId: Int) in
            ProductDetailViewModel(
                productId: productId,
                useCase: resolver.resolve(FetchProductDetailUseCase.self)!
            )
        }
    }
}
