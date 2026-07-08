import Swinject

// MARK: - DI Container
public class DIContainer {
    public static let shared = DIContainer()
    
    private let container: Container
    
    private init() {
        self.container = Container()
        registerDefaultServices()
    }
    
    // MARK: - Registration
    private func registerDefaultServices() {
        // Base container setup - modules will register their own services
    }
    
    /// Register a service in the container
    public func register<Service>(
        _ serviceType: Service.Type,
        factory: @escaping (Resolver) -> Service
    ) {
        container.register(serviceType) { factory($0) }
    }
    
    /// Register a service with a specific name
    public func register<Service>(
        _ serviceType: Service.Type,
        name: String?,
        factory: @escaping (Resolver) -> Service
    ) {
        container.register(serviceType, name: name) { factory($0) }
    }
    
    /// Resolve a service from the container
    public func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return container.resolve(serviceType)
    }
    
    /// Resolve a service with a specific name
    public func resolve<Service>(_ serviceType: Service.Type, name: String?) -> Service? {
        return container.resolve(serviceType, name: name)
    }
    
    /// Get the underlying Swinject container for advanced usage
    public func getContainer() -> Container {
        return container
    }
}

// MARK: - Module Assembly Protocol
public protocol DIAssembly {
    func assemble(container: Container)
}

// MARK: - Service Locator Helper
public class ServiceLocator {
    public static func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return DIContainer.shared.resolve(serviceType)
    }
}
