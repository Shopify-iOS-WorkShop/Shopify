import Foundation



@MainActor

public protocol ProductDetailRepositoryProtocol {

    func fetchProduct(id: Int) async throws -> ProductDetailEntity
    func createReview(productId: Int, input: ReviewInput) async throws -> ProductDetailEntity
    func updateReview(productId: Int, review: ReviewEntity, input: ReviewInput) async throws -> ProductDetailEntity
    func deleteReview(productId: Int, review: ReviewEntity) async throws -> ProductDetailEntity

}
