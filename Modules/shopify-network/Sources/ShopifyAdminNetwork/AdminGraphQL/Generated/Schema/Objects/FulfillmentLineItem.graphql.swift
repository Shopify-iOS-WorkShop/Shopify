// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// A line item from an [`Order`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Order) that's included in a [`Fulfillment`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Fulfillment). Links the fulfillment to specific items from the original order, tracking how many units were fulfilled.
  ///
  /// > Note: The discounted total excludes order-level discounts, showing only line-item specific discount amounts.
  static let FulfillmentLineItem = ApolloAPI.Object(
    typename: "FulfillmentLineItem",
    implementedInterfaces: [ShopifyAdminAPI.Interfaces.Node.self]
  )
}