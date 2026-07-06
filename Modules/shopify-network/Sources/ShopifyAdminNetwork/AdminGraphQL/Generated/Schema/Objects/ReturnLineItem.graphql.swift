// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// An item that a customer returns from a fulfilled order. Links to the original [`FulfillmentLineItem`](https://shopify.dev/docs/api/admin-graphql/latest/objects/FulfillmentLineItem) and tracks quantities through the return process.
  ///
  /// The line item includes the customer's reason for returning the item and any additional notes. It also tracks processing status with separate quantities for items that are processable, processed, refundable, and refunded. You can apply optional restocking fees to cover handling costs.
  ///
  /// Learn more about [creating a return](https://shopify.dev/docs/api/admin-graphql/latest/mutations/returnCreate).
  static let ReturnLineItem = ApolloAPI.Object(
    typename: "ReturnLineItem",
    implementedInterfaces: [
      ShopifyAdminAPI.Interfaces.Node.self,
      ShopifyAdminAPI.Interfaces.ReturnLineItemType.self
    ]
  )
}