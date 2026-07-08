// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// A representation of a search query in the Shopify admin used on resource index views. Preserves complex queries with search terms and filters, enabling merchants to quickly access frequently used data views. For example, a saved search can be applied to the product index table to filter products. The query string combines free-text search terms with structured filters to narrow results based on resource attributes.
  ///
  /// The search applies to a specific resource type such as [`Customer`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Customer), [`Product`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Product), [`Order`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Order), or [`Collection`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Collection) objects.
  static let SavedSearch = ApolloAPI.Object(
    typename: "SavedSearch",
    implementedInterfaces: [
      ShopifyAdminAPI.Interfaces.LegacyInteroperability.self,
      ShopifyAdminAPI.Interfaces.Node.self
    ]
  )
}