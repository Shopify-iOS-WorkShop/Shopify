import Foundation
import DependencyInjection
import Swinject

// MARK: - ShopifyNetwork Assembly for Dependency Injection
public class ShopifyNetworkAssembly: DIAssembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(NetworkClient.self) { _ in
            URLSessionNetworkClient()
        }

        container.register(GraphQLClientProtocol.self) { _ in
            GraphQLClient()
        }
        .inObjectScope(.container)

        container.register(GraphQLClient.self) { _ in
            GraphQLClient()
        }
        .inObjectScope(.container)
    }
}
