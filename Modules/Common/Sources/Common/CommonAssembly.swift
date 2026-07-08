import DependencyInjection
import Swinject

// MARK: - Common Assembly for Dependency Injection
public class CommonAssembly: DIAssembly {

    public init() {}

    public func assemble(container: Container) {
        // Register SessionStore as singleton
        container.register(SessionStore.self) { _ in
            SessionStore()
        }.inObjectScope(.container)
        
        // Register SessionProviding protocol binding
        container.register(SessionProviding.self) { resolver in
            resolver.resolve(SessionStore.self)!
        }.inObjectScope(.container)

        // Register CurrencyStore as singleton — shared across all modules
        container.register(CurrencyStore.self) { _ in
            CurrencyStore()
        }.inObjectScope(.container)
    }
}
