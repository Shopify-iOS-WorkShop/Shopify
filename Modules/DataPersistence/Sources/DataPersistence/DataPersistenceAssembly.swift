import DependencyInjection
import Swinject
import SwiftData

// MARK: - DataPersistence Assembly for Dependency Injection
public class DataPersistenceAssembly: DIAssembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        // Note: ModelContext must be registered by the app-level assembly before this module
        
        // Register SwiftData Client
        container.register(SwiftDataClient.self) { resolver in
            guard let modelContext = resolver.resolve(ModelContext.self) else {
                fatalError("ModelContext must be registered before DataPersistenceAssembly. Register it in AppAssembly.")
            }
            return SwiftDataClient(context: modelContext)
        }
        
        // Register LocalDatabaseClientProtocol
        container.register(LocalDatabaseClientProtocol.self) { resolver in
            resolver.resolve(SwiftDataClient.self)!
        }
    }
}
