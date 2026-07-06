//
//  File.swift
//
//
//  Created by Mazen Amr on 04/07/2026.
//

import Foundation
import Apollo
import ShopifyNetwork

public class AdminGraphQLClient {
    public static let shared = AdminGraphQLClient()
    public private(set) var apollo: ApolloClient
    
    private init() {
        let url = URL(string: "https://\(ShopifyConfig.hostname)/admin/api/\(ShopifyConfig.apiVersion)/graphql.json")!
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["X-Shopify-Access-Token": ShopifyConfig.accessToken]
        
        let sessionClient = URLSessionClient(sessionConfiguration: configuration)
        let provider = DefaultInterceptorProvider(client: sessionClient, store: ApolloStore())
        let requestChainTransport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: url)
        
        self.apollo = ApolloClient(networkTransport: requestChainTransport, store: ApolloStore())
    }
}
