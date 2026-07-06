// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Interfaces {
  /// A list of products with publishing and pricing information.
  /// A catalog can be associated with a specific context, such as a [`Market`](https://shopify.dev/api/admin-graphql/current/objects/market), [`CompanyLocation`](https://shopify.dev/api/admin-graphql/current/objects/companylocation), or [`App`](https://shopify.dev/api/admin-graphql/current/objects/app).
  ///
  /// Catalogs can optionally include a publication to control product visibility and a price list to customize pricing. When a publication isn't associated with a catalog, product availability is determined by the sales channel.
  static let Catalog = Interface(name: "Catalog")
}