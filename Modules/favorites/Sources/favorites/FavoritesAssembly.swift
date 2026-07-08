import DependencyInjection
import DataPersistence
import Swinject
import Common

public class FavoritesAssembly: DIAssembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(FavoritesLocalDataSource.self) { resolver in
            guard let client = resolver.resolve(LocalDatabaseClientProtocol.self) else {
                fatalError("LocalDatabaseClientProtocol must be registered before FavoritesAssembly. Register DataPersistenceAssembly first.")
            }
            return FavoritesLocalDataSource(client: client)
        }

        container.register(FavoritesRepositoryProtocol.self) { resolver in
            guard let sessionProvider = resolver.resolve(SessionProviding.self) else {
                fatalError("SessionProviding must be registered before FavoritesAssembly. Register CommonAssembly or equivalent first.")
            }
            return FavoritesRepository(
                localDataSource: resolver.resolve(FavoritesLocalDataSource.self)!,
                sessionProvider: sessionProvider
            )
        }

      
        container.register(AddToFavoritesUseCase.self) { resolver in
            AddToFavoritesUseCase(repository: resolver.resolve(FavoritesRepositoryProtocol.self)!)
        }

        container.register(RemoveFromFavoritesUseCase.self) { resolver in
            RemoveFromFavoritesUseCase(repository: resolver.resolve(FavoritesRepositoryProtocol.self)!)
        }

        container.register(FetchFavoritesUseCase.self) { resolver in
            FetchFavoritesUseCase(repository: resolver.resolve(FavoritesRepositoryProtocol.self)!)
        }

        container.register(IsFavoriteUseCase.self) { resolver in
            IsFavoriteUseCase(repository: resolver.resolve(FavoritesRepositoryProtocol.self)!)
        }
    }
}
