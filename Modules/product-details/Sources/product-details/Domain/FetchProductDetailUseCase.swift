import Foundation



@MainActor

public protocol FetchProductDetailUseCaseProtocol {

    func execute(productId: Int) async throws -> ProductDetailEntity

}



public final class FetchProductDetailUseCase: FetchProductDetailUseCaseProtocol {



    private let repository: ProductDetailRepositoryProtocol



    public init(repository: ProductDetailRepositoryProtocol) {

        self.repository = repository

    }



    public func execute(productId: Int) async throws -> ProductDetailEntity {

        try await repository.fetchProduct(id: productId)

    }

}
