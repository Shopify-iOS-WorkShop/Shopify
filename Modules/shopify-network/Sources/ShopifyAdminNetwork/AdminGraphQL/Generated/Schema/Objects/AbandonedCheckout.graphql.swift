// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// An incomplete checkout where the customer added items and provided contact information but didn't complete the purchase. Tracks the customer's cart contents, pricing details, addresses, and timestamps to enable recovery campaigns and abandonment analytics.
  ///
  /// The checkout includes a recovery URL that merchants can send to customers to resume their purchase. [`AbandonedCheckoutLineItem`](https://shopify.dev/docs/api/admin-graphql/latest/objects/AbandonedCheckoutLineItem) objects preserve the original [`Product`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Product) selections, quantities, and pricing at the time of abandonment.
  static let AbandonedCheckout = ApolloAPI.Object(
    typename: "AbandonedCheckout",
    implementedInterfaces: [
      ShopifyAdminAPI.Interfaces.Navigable.self,
      ShopifyAdminAPI.Interfaces.Node.self
    ]
  )
}