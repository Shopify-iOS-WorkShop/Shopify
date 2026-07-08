import Foundation



@MainActor

public protocol FetchProductDetailUseCaseProtocol {

    func execute(productId: Int) async throws -> ProductDetailEntity
    func createReview(productId: Int, input: ReviewInput) async throws -> ProductDetailEntity
    func updateReview(productId: Int, review: ReviewEntity, input: ReviewInput) async throws -> ProductDetailEntity
    func deleteReview(productId: Int, review: ReviewEntity) async throws -> ProductDetailEntity

}



public final class FetchProductDetailUseCase: FetchProductDetailUseCaseProtocol {



    private let repository: ProductDetailRepositoryProtocol



    public init(repository: ProductDetailRepositoryProtocol) {

        self.repository = repository

    }



    public func execute(productId: Int) async throws -> ProductDetailEntity {

        try await repository.fetchProduct(id: productId)

    }

    public func createReview(productId: Int, input: ReviewInput) async throws -> ProductDetailEntity {
        try await repository.createReview(productId: productId, input: input)
    }

    public func updateReview(productId: Int, review: ReviewEntity, input: ReviewInput) async throws -> ProductDetailEntity {
        try await repository.updateReview(productId: productId, review: review, input: input)
    }

    public func deleteReview(productId: Int, review: ReviewEntity) async throws -> ProductDetailEntity {
        try await repository.deleteReview(productId: productId, review: review)
    }

}
