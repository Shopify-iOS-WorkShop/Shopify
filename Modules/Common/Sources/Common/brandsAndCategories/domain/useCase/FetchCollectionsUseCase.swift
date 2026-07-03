//
//  domain.swift
//  Common
//
//  Created by Mina on 01/07/2026.
//

import Foundation
import ShopifyNetwork

public class FetchCollectionsUseCase: FetchCollectionsUseCaseProtocol {
    private let networkClient: NetworkClient
    private let defaultImageString = "https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?q=80&w=600"
    
    public init(networkClient: NetworkClient = URLSessionNetworkClient()) {
        self.networkClient = networkClient
    }
    
    public func execute() async throws -> (brands: [GridItemEntity], categories: [GridItemEntity]) {
        let endpoint = CollectionsEndpoint()
        let response: ShopifyCollectionsResponse = try await networkClient.request(endpoint: endpoint)
        
        var brands: [GridItemEntity] = []
        var categories: [GridItemEntity] = []
        
        for edge in response.data.collections.edges {
            let node = edge.node
            
            guard let imageString = node.image?.url else {
                continue
            }
            
            let entity = GridItemEntity(
                id: node.id,
                name: node.title,
                imageURL: URL(string: imageString),
                isDefaultImage: false
            )
            
            if imageString.contains("custom_collections") {
                categories.append(entity)
            } else if imageString.contains("smart_collections") {
                brands.append(entity)
            } else {
                brands.append(entity)
            }
        }
        
        return (brands, categories)
    }
}
