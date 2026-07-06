// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// A list of products with publishing and pricing information associated with company locations.
  ///
  /// Company location catalogs can include an optional publication to control product visibility and a price list to customize pricing. When a publication isn't associated with the catalog, product availability is determined by the sales channel.
  static let CompanyLocationCatalog = ApolloAPI.Object(
    typename: "CompanyLocationCatalog",
    implementedInterfaces: [
      ShopifyAdminAPI.Interfaces.Catalog.self,
      ShopifyAdminAPI.Interfaces.Node.self
    ]
  )
}