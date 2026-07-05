import Foundation
import DependencyInjection
import Swinject

public enum SearchFactory {

    @MainActor
    public static func makeViewModel(container: Container) -> SearchViewModel {
        SearchViewModel(
            useCase: container.resolve(SearchUseCase.self)!
        )
    }
}
