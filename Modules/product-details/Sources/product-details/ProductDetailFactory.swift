import SwiftUI

import ShopifyNetwork



public enum ProductDetailFactory {



// Add 'public' here so your app module can call this method

@MainActor

public static func makeView(
    productId: Int,
    networkClient: NetworkClient = URLSessionNetworkClient(),
    onAddToCart: ProductDetailViewModel.AddToCartAction? = nil
) -> some View {

// Inject the protocol-oriented networkClient into the repository

let repository = ProductDetailRepository(networkClient: networkClient)

let useCase = FetchProductDetailUseCase(repository: repository)

let viewModel = ProductDetailViewModel(
    productId: productId,
    useCase: useCase,
    addToCartAction: onAddToCart
)

return ProductDetailView(viewModel: viewModel)

}

}
