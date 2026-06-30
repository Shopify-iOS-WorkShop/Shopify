import Foundation



@MainActor

public protocol ProductDetailRepositoryProtocol {

    func fetchProduct(id: Int) async throws -> ProductDetailEntity

}
