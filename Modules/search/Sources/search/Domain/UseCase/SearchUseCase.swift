import Foundation

public final class SearchUseCase: Sendable {
    private let repository: SearchRepositoryProtocol
    
    public init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }
    
    public func executePredictiveSearch(query: String) async throws -> (products: [SearchProduct], collections: [SearchCollection]) {
        return try await repository.predictiveSearch(query: query)
    }
    
    public func executeSearchProducts(query: String, first: Int = 10, after: String? = nil) async throws -> (products: [SearchProduct], pageInfo: PageInfo) {
        return try await repository.searchProducts(query: query, first: first, after: after)
    }
}
