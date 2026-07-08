// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// A legal entity through which a merchant operates. Each business entity contains its own [`BusinessEntityAddress`](https://shopify.dev/docs/api/admin-graphql/latest/objects/BusinessEntityAddress), company information, and can be associated with its own [`ShopifyPaymentsAccount`](https://shopify.dev/docs/api/admin-graphql/latest/objects/ShopifyPaymentsAccount). [`Market`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Market) objects can be assigned to a business entity to determine payment processing and [`Order`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Order) attribution.
  ///
  /// Every shop must have one primary business entity. Additional entities enable international operations by establishing legal presence in multiple countries.
  ///
  /// Learn more about [managing multiple legal entities](https://shopify.dev/docs/apps/build/markets/multiple-entities).
  static let BusinessEntity = ApolloAPI.Object(
    typename: "BusinessEntity",
    implementedInterfaces: [ShopifyAdminAPI.Interfaces.Node.self]
  )
}