import Foundation

import Combine



@MainActor

public final class ProductDetailViewModel: ObservableObject {



    // MARK: - State



    enum ViewState {

        case idle

        case loading

        case success(ProductDetailEntity)

        case failure(String)

    }



    @Published private(set) var state: ViewState = .idle

    @Published public private(set) var selectedSize: String? = nil

    @Published public private(set) var quantity: Int = 1

    @Published public private(set) var isFavorite: Bool = false

    @Published public private(set) var isDescriptionExpanded: Bool = true

    @Published public private(set) var currentImageIndex: Int = 0



    // MARK: - Dependencies



    private let useCase: FetchProductDetailUseCaseProtocol

    private let productId: Int



    // MARK: - Init



    public init(productId: Int, useCase: FetchProductDetailUseCaseProtocol) {

        self.productId = productId

        self.useCase = useCase

    }



    // MARK: - Intents



    public func onAppear() {

        Task { await loadProduct() }

    }



    public func selectSize(_ size: String) {

        selectedSize = size

    }



    public func incrementQuantity() {

        quantity += 1

    }



    public func decrementQuantity() {

        guard quantity > 1 else { return }

        quantity -= 1

    }



    public func toggleFavorite() {

        isFavorite.toggle()

    }



    public func toggleDescription() {

        isDescriptionExpanded.toggle()

    }



    public func setImageIndex(_ index: Int) {

        currentImageIndex = index

    }



    public func addToCart() {

        guard selectedSize != nil else { return }

        // Hook into your cart use case here

    }



    // MARK: - Private



    private func loadProduct() async {

        state = .loading

        do {

            let entity = try await useCase.execute(productId: productId)

            selectedSize = entity.sizes.first

            isFavorite = entity.isFavorite

            state = .success(entity)

        } catch {

            state = .failure(error.localizedDescription)

        }

    }

}
