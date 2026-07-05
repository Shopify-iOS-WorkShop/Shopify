import Foundation
import DependencyInjection
import Swinject

public enum FavoritesFactory {

   
    @MainActor
    public static func makeViewModel(container: Container) -> FavoritesViewModel {
        FavoritesViewModel(
            fetchFavoritesUseCase: container.resolve(FetchFavoritesUseCase.self)!,
            addToFavoritesUseCase: container.resolve(AddToFavoritesUseCase.self)!,
            removeFromFavoritesUseCase: container.resolve(RemoveFromFavoritesUseCase.self)!,
            isFavoriteUseCase: container.resolve(IsFavoriteUseCase.self)!
        )
    }
}
