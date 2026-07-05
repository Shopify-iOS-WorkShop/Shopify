import SwiftUI
import ShopifyNetwork

public enum ProductDetailFactory {

    @MainActor
    public static func makeView(
        productId: Int,
        networkClient: NetworkClient = URLSessionNetworkClient(),
        checkIsFavorite: ((String) -> Bool)? = nil,
        onToggleFavorite: ((String, String, String, Double, Double, String?) -> Void)? = nil
    ) -> some View {
        let repository = ProductDetailRepository(networkClient: networkClient)
        let useCase = FetchProductDetailUseCase(repository: repository)
        let viewModel = ProductDetailViewModel(productId: productId, useCase: useCase)
        viewModel.checkIsFavorite = checkIsFavorite
        viewModel.onToggleFavorite = onToggleFavorite
        return ProductDetailView(viewModel: viewModel)
    }
}
