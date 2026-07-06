// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// Additional fees applied to an [`Order`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Order) beyond the standard product and shipping costs. Additional fees typically include duties, import fees, or other special handling charges that need separate tracking from regular [`LineItem`](https://shopify.dev/docs/api/admin-graphql/latest/objects/LineItem) objects.
  ///
  /// Each fee includes its name, price in both shop and presentment currencies, and any applicable taxes broken down by [`TaxLine`](https://shopify.dev/docs/api/admin-graphql/latest/objects/TaxLine).
  static let AdditionalFee = ApolloAPI.Object(
    typename: "AdditionalFee",
    implementedInterfaces: [ShopifyAdminAPI.Interfaces.Node.self]
  )
}