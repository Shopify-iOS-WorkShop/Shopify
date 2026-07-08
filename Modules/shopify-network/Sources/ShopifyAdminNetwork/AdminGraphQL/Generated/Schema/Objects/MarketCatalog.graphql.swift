// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// A catalog for managing product availability and pricing for specific [`Market`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Market) contexts. Each catalog links to one or more markets. The catalog can optionally include a [`Publication`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Publication) to control which [`Product`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Product) objects customers see, and a [`PriceList`](https://shopify.dev/docs/api/admin-graphql/latest/objects/PriceList) for market-specific pricing adjustments. When a publication isn't associated with the catalog, product availability is determined by the sales channel.
  ///
  /// Use catalogs to create distinct shopping experiences for different geographic regions or customer segments.
  ///
  /// Learn more about [building a catalog](https://shopify.dev/docs/apps/build/markets/build-catalog) and [managing markets](https://shopify.dev/docs/apps/build/markets).
  static let MarketCatalog = ApolloAPI.Object(
    typename: "MarketCatalog",
    implementedInterfaces: [
      ShopifyAdminAPI.Interfaces.Catalog.self,
      ShopifyAdminAPI.Interfaces.Node.self
    ]
  )
}