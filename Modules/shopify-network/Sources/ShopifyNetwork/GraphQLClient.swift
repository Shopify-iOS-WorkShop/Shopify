import Foundation
import Apollo
import ApolloAPI

public enum GraphQLNetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case graphqlErrors([Apollo.GraphQLError])
}

public protocol GraphQLClientProtocol {
    func fetch<Query: GraphQLQuery>(query: Query) async throws -> Query.Data
    func perform<Mutation: GraphQLMutation>(mutation: Mutation) async throws -> Mutation.Data
}

public class GraphQLClient: GraphQLClientProtocol {
    public static let shared = GraphQLClient()
    
    private let apollo: ApolloClient
    
    public init() {
        let urlString = "https://\(ShopifyConfig.hostname)/api/\(ShopifyConfig.apiVersion)/graphql.json"
        guard let url = URL(string: urlString) else {
            fatalError("Invalid Storefront URL")
        }
        
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let provider = DefaultInterceptorProvider.shared
        let requestChainTransport = RequestChainNetworkTransport(
            urlSession: URLSession.shared,
            interceptorProvider: provider,
            store: store,
            endpointURL: url,
            additionalHeaders: [
                "X-Shopify-Storefront-Access-Token": ShopifyConfig.storefrontToken,
                "Content-Type": "application/json"
            ]
        )
        
        self.apollo = ApolloClient(networkTransport: requestChainTransport, store: store)
    }
    
    public func fetch<Query: GraphQLQuery>(query: Query) async throws -> Query.Data {
        return try await withCheckedThrowingContinuation { continuation in
            apollo.fetch(query: query) { result in
                switch result {
                case .success(let graphQLResult):
                    if let errors = graphQLResult.errors, !errors.isEmpty {
                        continuation.resume(throwing: GraphQLNetworkError.graphqlErrors(errors))
                    } else if let data = graphQLResult.data {
                        continuation.resume(returning: data)
                    } else {
                        let unknownError = NSError(domain: "GraphQLClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data and no errors returned"])
                        continuation.resume(throwing: GraphQLNetworkError.requestFailed(unknownError))
                    }
                case .failure(let error):
                    continuation.resume(throwing: GraphQLNetworkError.requestFailed(error))
                }
            }
        }
    }
    
    public func perform<Mutation: GraphQLMutation>(mutation: Mutation) async throws -> Mutation.Data {
        return try await withCheckedThrowingContinuation { continuation in
            apollo.perform(mutation: mutation) { result in
                switch result {
                case .success(let graphQLResult):
                    if let errors = graphQLResult.errors, !errors.isEmpty {
                        continuation.resume(throwing: GraphQLNetworkError.graphqlErrors(errors))
                    } else if let data = graphQLResult.data {
                        continuation.resume(returning: data)
                    } else {
                        let unknownError = NSError(domain: "GraphQLClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data and no errors returned"])
                        continuation.resume(throwing: GraphQLNetworkError.requestFailed(unknownError))
                    }
                case .failure(let error):
                    continuation.resume(throwing: GraphQLNetworkError.requestFailed(error))
                }
            }
        }
    }
}
