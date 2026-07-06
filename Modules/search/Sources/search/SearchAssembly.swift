import DependencyInjection
import Swinject

public class SearchAssembly: DIAssembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(SearchRepositoryProtocol.self) { _ in
            SearchRepository()
        }

        container.register(SearchUseCase.self) { resolver in
            SearchUseCase(repository: resolver.resolve(SearchRepositoryProtocol.self)!)
        }

       
    }
}
