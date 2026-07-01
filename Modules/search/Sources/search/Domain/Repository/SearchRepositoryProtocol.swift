import Foundation

public protocol SearchRepositoryProtocol {
    func predictiveSearch(query: String) async throws -> (products: [SearchProduct], collections: [SearchCollection])
    func searchProducts(query: String, first: Int, after: String?) async throws -> (products: [SearchProduct], pageInfo: PageInfo)
}
