import Foundation
import ShopifyNetwork

struct ProductsResponseDTO: Decodable {
    let products: [ShopifyProductDTO]
}

public class ProductListingRepository: ProductListingRepositoryProtocol {
    private let networkClient: NetworkClient
    
    public init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    public func fetchAllProducts() async throws -> [Product] {
        let endpoint = ProductListingEndpoint.allProducts
        let response: ProductsResponseDTO = try await networkClient.request(endpoint: endpoint)
        return response.products.map { $0.toDomain() }
    }
    
    public func fetchProductsForCollection(id: String) async throws -> [Product] {
        let endpoint = ProductListingEndpoint.collectionProducts(id: id)
        let response: ProductsResponseDTO = try await networkClient.request(endpoint: endpoint)
        print(response.products)
        return response.products.map {$0.toDomain()}
    }
}
