import DependencyInjection
import Swinject

// MARK: - Common Assembly for Dependency Injection
public class CommonAssembly: DIAssembly {

    public init() {}

    public func assemble(container: Container) {
        // Common shared services will be registered here as they are introduced.
    }
}
