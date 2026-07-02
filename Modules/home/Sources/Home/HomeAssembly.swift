import DependencyInjection
import Swinject
import ShopifyNetwork

// MARK: - Home Assembly for Dependency Injection
public class HomeAssembly: DIAssembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(HomeRepositoryProtocol.self) { resolver in
            HomeRepository(networkClient: resolver.resolve(NetworkClient.self)!)
        }

        container.register(HomeViewModel.self) { @MainActor resolver in
            HomeViewModel(repository: resolver.resolve(HomeRepositoryProtocol.self)!)
        }
    }
}
