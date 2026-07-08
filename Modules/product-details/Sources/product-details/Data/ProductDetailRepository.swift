import Foundation

import ShopifyNetwork



// 1. Create a local Sendable typealias interface wrapper

// to satisfy strict cross-actor isolation checks safely.

private struct SendableNetworkWrapper: @unchecked Sendable {

    let client: NetworkClient

    

    func request<T: Decodable>(endpoint: Endpoint) async throws -> T {

        try await client.request(endpoint: endpoint)

    }

}



@MainActor

public final class ProductDetailRepository: ProductDetailRepositoryProtocol, @unchecked Sendable {



    // 2. Hold the safe wrapper instead of the raw non-Sendable protocol instance directly

    private let networkWrapper: SendableNetworkWrapper



    public init(networkClient: NetworkClient) {

        self.networkWrapper = SendableNetworkWrapper(client: networkClient)

    }



    public func fetchProduct(id: Int) async throws -> ProductDetailEntity {

        let endpoint = ShopifyProductEndpoint.getProduct(id: id)

        

        // 3. Make the request via the wrapper—clearing the data race warning instantly

        let response: ProductResponse = try await networkWrapper.request(endpoint: endpoint)

        

        guard let product = response.product else {

            throw NSError(

                domain: "ProductDetailRepository",

                code: 404,

                userInfo: [NSLocalizedDescriptionKey: "Product details not found in the response wrapper."]

            )

        }

        

        return ProductDetailMapper.map(product)

    }

}
