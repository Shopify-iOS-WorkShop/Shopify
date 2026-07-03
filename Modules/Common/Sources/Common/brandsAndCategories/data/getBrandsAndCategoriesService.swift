//
//  myData.swift
//  Common
//
//  Created by Mina on 01/07/2026.
//

import Foundation
import ShopifyNetwork

public struct GraphQLPayload: Encodable {
    public let query: String
    public let variables: [String: AnyEncodable]
    
    public init(query: String, variables: [String: AnyEncodable]) {
        self.query = query
        self.variables = variables
    }
}

public struct AnyEncodable: Encodable {
    private let encode: (Encoder) throws -> Void
    public init<T: Encodable>(_ value: T) {
        self.encode = value.encode
    }
    public func encode(to encoder: Encoder) throws {
        try encode(encoder)
    }
}

public struct ShopifyCollectionsResponse: Decodable {
    public let data: CollectionsData
}

public struct CollectionsData: Decodable {
    public let collections: CollectionConnection
}

public struct CollectionConnection: Decodable {
    public let edges: [CollectionEdge]
}

public struct CollectionEdge: Decodable {
    public let node: CollectionNode
}

public struct CollectionNode: Decodable {
    public let id: String
    public let title: String
    public let handle: String
    public let description: String
    public let image: ShopifyImage?
}

public struct ShopifyImage: Decodable {
    public let url: String
    public let altText: String?
}

public struct CollectionsEndpoint: Endpoint {
    public var baseURL: String { "https://\(ShopifyConfig.hostname)" }
    public var path: String { "/api/\(ShopifyConfig.apiVersion)/graphql.json" }
    public var method: String { "POST" }
    
    public var headers: [String: String]? {
        [
            "X-Shopify-Storefront-Access-Token": ShopifyConfig.storefrontToken,
            "Content-Type": "application/json"
        ]
    }
    
    public var queryItems: [URLQueryItem]? { nil }
    public var body: Data?
    
    public init(first: Int = 50, after: String? = nil) {
        let queryString = """
        query GetCollections($first: Int!, $after: String) {
          collections(first: $first, after: $after) {
            edges {
              node {
                id
                title
                handle
                description
                image { url altText }
                products(first: 1) {
                  edges { node { id } }
                }
              }
            }
            pageInfo { hasNextPage endCursor }
          }
        }
        """
        
        let variables: [String: AnyEncodable] = [
            "first": AnyEncodable(first),
            "after": AnyEncodable(after)
        ]
        
        let payload = GraphQLPayload(query: queryString, variables: variables)
        self.body = try? JSONEncoder().encode(payload)
    }
}
