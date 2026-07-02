import DependencyInjection
import Swinject

// MARK: - DataPersistence Assembly for Dependency Injection
public class DataPersistenceAssembly: DIAssembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        // Register SwiftData Client
        container.register(SwiftDataClient.self) { resolver in
            let modelContext = resolver.resolve(ModelContext.self)!
            return SwiftDataClient(context: modelContext)
        }
        
        // Register Database Service
        container.register(DatabaseService.self) { resolver in
            DatabaseServiceImpl(dataClient: resolver.resolve(SwiftDataClient.self)!)
        }
        
        // Register Keychain Service
        container.register(KeychainService.self) { _ in
            KeychainServiceImpl()
        }
        
        // Register UserDefaults Service
        container.register(UserDefaultsService.self) { _ in
            UserDefaultsServiceImpl()
        }
    }
}
