 
 //
//  File.swift
//  
//
//  Created by Mazen Amr on 27/06/2026.
//

import Foundation
import ShopifyNetwork

public class HomeRepository: HomeRepositoryProtocol {
    private let networkClient: NetworkClient
    
    public init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    public func fetchBestSellers() async throws -> [Product] {
        let response: ShopifyProductResponse = try await networkClient.request(endpoint: HomeEndpoint.getProducts)
        return response.products.map { $0.toDomain() }
    }
    public func fetchBrands() async throws -> [Brand] {
        let response: SmartCollectionResponse = try await networkClient.request(endpoint: HomeEndpoint.getSmartCollections)
        return response.smart_collections.map { $0.toBrand() }
    }
    
    public func fetchCategories() async throws -> [Category] {
        let response: CustomCollectionResponse = try await networkClient.request(endpoint: HomeEndpoint.getCustomCollections)
        return response.custom_collections.map { $0.toCategory() }
    }
}
