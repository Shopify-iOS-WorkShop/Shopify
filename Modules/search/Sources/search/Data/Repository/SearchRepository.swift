import Foundation
import ShopifyNetwork
import Apollo

public class SearchRepository: SearchRepositoryProtocol {
    private let client: GraphQLClientProtocol
    
    public init(client: GraphQLClientProtocol = GraphQLClient.shared) {
        self.client = client
    }
    
    public func predictiveSearch(query: String) async throws -> (products: [SearchProduct], collections: [SearchCollection]) {
        let gqlQuery = ShopifyAPI.PredictiveSearchQuery(query: query)
        let data = try await client.fetch(query: gqlQuery)
        
        let products = data.predictiveSearch?.products.compactMap { product -> SearchProduct? in
            let id = product.id
            let title = product.title
            let vendor = product.vendor
            let price = product.priceRange.minVariantPrice.amount
            let currency = product.priceRange.minVariantPrice.currencyCode.rawValue
            let imageUrl = URL(string: product.images.edges.first?.node.url ?? "")
            
            return SearchProduct(id: id, title: title, vendor: vendor, price: price, currencyCode: currency, imageUrl: imageUrl)
        } ?? []
        
        let collections = data.predictiveSearch?.collections.compactMap { collection -> SearchCollection? in
            let id = collection.id
            let title = collection.title
            let handle = collection.handle
            let imageUrl = URL(string: collection.image?.url ?? "")
            
            return SearchCollection(id: id, title: title, handle: handle, imageUrl: imageUrl)
        } ?? []
        
        return (products, collections)
    }
    
    public func searchProducts(query: String, first: Int, after: String?) async throws -> (products: [SearchProduct], pageInfo: PageInfo) {
        let afterCursor: GraphQLNullable<String> = after != nil ? .some(after!) : .none
        let gqlQuery = ShopifyAPI.SearchProductsQuery(query: query, first: Int32(first), after: afterCursor)
        let data = try await client.fetch(query: gqlQuery)
        
        let products = data.search.edges.compactMap { edge -> SearchProduct? in
            guard let node = edge.node.asProduct else { return nil }
            let id = node.id
            let title = node.title
            let vendor = node.vendor
            let availableForSale = node.availableForSale
            let price = node.priceRange.minVariantPrice.amount
            let currency = node.priceRange.minVariantPrice.currencyCode.rawValue
            let imageUrl = URL(string: node.images.edges.first?.node.url ?? "")
            let variants = node.variants.edges.map { variantEdge -> SearchProductVariant in
                let vNode = variantEdge.node
                return SearchProductVariant(
                    id: vNode.id,
                    title: vNode.title,
                    availableForSale: vNode.availableForSale,
                    quantityAvailable: vNode.quantityAvailable,
                    price: vNode.price.amount,
                    currencyCode: vNode.price.currencyCode.rawValue
                )
            }
            
            return SearchProduct(id: id, title: title, vendor: vendor, price: price, currencyCode: currency, imageUrl: imageUrl, availableForSale: availableForSale, variants: variants)
        }
        
        let pageInfo = PageInfo(hasNextPage: data.search.pageInfo.hasNextPage, endCursor: data.search.pageInfo.endCursor)
        
        return (products, pageInfo)
    }
}
