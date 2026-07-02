import DependencyInjection
import Swinject
import Apollo

// MARK: - ShopifyNetwork Assembly for Dependency Injection
public class ShopifyNetworkAssembly: DIAssembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        // Register NetworkClient
        container.register(NetworkClient.self) { _ in
            URLSessionNetworkClient()
        }
        
        // Register GraphQLClient
        container.register(GraphQLClient.self) { resolver in
            let networkClient = resolver.resolve(NetworkClient.self)!
            return GraphQLClient(networkClient: networkClient)
        }
        
        // Register Apollo Client
        container.register(ApolloClient.self) { _ in
            ApolloClient(url: URL(string: "https://shopify-graphql-api.example.com/graphql")!)
        }
    }
}
