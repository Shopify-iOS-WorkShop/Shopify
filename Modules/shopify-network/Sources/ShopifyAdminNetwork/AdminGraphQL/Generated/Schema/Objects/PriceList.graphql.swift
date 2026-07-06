// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// A list that defines pricing for [product variants](https://shopify.dev/docs/api/admin-graphql/latest/objects/ProductVariant). Price lists override default product prices with either fixed prices or percentage-based adjustments.
  ///
  /// Each price list associates with a [`Catalog`](https://shopify.dev/docs/api/admin-graphql/latest/interfaces/Catalog) to determine which customers see the pricing. The catalog's context rules control when the price list applies, such as for specific markets, company locations, or apps.
  ///
  /// Learn how to [support different pricing models](https://shopify.dev/docs/apps/build/markets/build-catalog).
  static let PriceList = ApolloAPI.Object(
    typename: "PriceList",
    implementedInterfaces: [ShopifyAdminAPI.Interfaces.Node.self]
  )
}