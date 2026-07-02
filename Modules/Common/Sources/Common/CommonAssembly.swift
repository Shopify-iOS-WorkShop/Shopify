import DependencyInjection
import Swinject

// MARK: - Common Assembly for Dependency Injection
public class CommonAssembly: DIAssembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        // Register Common Services
        container.register(NavigationService.self) { _ in
            NavigationServiceImpl()
        }
        
        container.register(LocalStorageService.self) { _ in
            LocalStorageServiceImpl()
        }
        
        container.register(LoggingService.self) { _ in
            LoggingServiceImpl()
        }
        
        container.register(ValidationService.self) { _ in
            ValidationServiceImpl()
        }
    }
}
