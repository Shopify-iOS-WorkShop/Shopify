import Foundation
import SwiftData
import DataPersistence
import ShopifyNetwork
import Common

@MainActor
public final class CartFactory {
    
    public static func makeCart(
        sessionProvider: SessionProviding,
        modelContext: ModelContext,
        networkClient: NetworkClient
    ) -> (coordinator: CartCoordinator, viewModel: CartViewModel) {
        
        let graphQLClient = GraphQLClient(networkClient: networkClient)
        let remoteDataSource = CartRemoteDataSource(client: graphQLClient)
        
        let dbClient = SwiftDataClient(context: modelContext)
        let localDataSource = CartLocalDataSource(dbClient: dbClient)
        
        let repository = CartRepositoryImpl(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource,
            sessionStore: sessionProvider
        )
        
        let getOrCreateCart = GetOrCreateCartUseCase(repository: repository)
        let addCartLine = AddCartLineUseCase(repository: repository)
        let updateQuantity = UpdateCartLineQuantityUseCase(repository: repository)
        let removeLine = RemoveCartLineUseCase(repository: repository)
        let applyDiscount = ApplyDiscountCodeUseCase(repository: repository)
        let removeDiscount = RemoveDiscountCodeUseCase(repository: repository)
        let observeCart = ObserveCartUseCase(repository: repository)
        let clearCart = ClearCartUseCase(repository: repository)
        
        let viewModel = CartViewModel(
            getOrCreateCartUseCase: getOrCreateCart,
            addCartLineUseCase: addCartLine,
            updateQuantityUseCase: updateQuantity,
            removeLineUseCase: removeLine,
            applyDiscountUseCase: applyDiscount,
            removeDiscountUseCase: removeDiscount,
            observeCartUseCase: observeCart,
            clearCartUseCase: clearCart,
            sessionStore: sessionProvider
        )
        
        let coordinator = CartCoordinator()
        
        viewModel.onCheckoutTapped = { [weak coordinator] url in
            coordinator?.navigateTo(.checkout, currentCheckoutUrl: url)
        }
        viewModel.onSignInRequired = { [weak coordinator] in
            coordinator?.navigateTo(.signInRequired)
        }
        viewModel.onProductTapped = { [weak coordinator] id, handle in
            coordinator?.navigateTo(.productDetails(productId: id, handle: handle))
        }
        
        return (coordinator, viewModel)
    }
}
