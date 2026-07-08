import SwiftUI
import Common
import ShopifyNetwork

public enum ProductDetailFactory {

    @MainActor
    public static func makeView(
        productId: Int,
        networkClient: NetworkClient = URLSessionNetworkClient(),
        sessionProvider: SessionProviding? = nil,
        checkIsFavorite: ((String) -> Bool)? = nil,
        onToggleFavorite: ((String, String, String, Double, Double, String?) -> Void)? = nil,
        onAddToCart: ProductDetailViewModel.AddToCartAction? = nil
    ) -> some View {
        let repository = ProductDetailRepository(networkClient: networkClient, sessionProvider: sessionProvider)
        let useCase = FetchProductDetailUseCase(repository: repository)
        
        let viewModel = ProductDetailViewModel(
            productId: productId,
            useCase: useCase,
            addToCartAction: onAddToCart
        )
        
        viewModel.checkIsFavorite = checkIsFavorite
        viewModel.onToggleFavorite = onToggleFavorite
        
        return ProductDetailView(viewModel: viewModel)
    }
}
