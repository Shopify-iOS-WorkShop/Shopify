// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// Information about the delivery method selected for a [`FulfillmentOrder`](https://shopify.dev/docs/api/admin-graphql/latest/objects/FulfillmentOrder). Includes the method type, expected delivery timeframe, and any additional information needed for delivery.
  ///
  /// The delivery method stores details from checkout such as the carrier, branded promises like Shop Promise, and the delivery option name shown to the buyer. Additional information like delivery instructions or contact phone numbers helps fulfill the [`Order`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Order) correctly.
  static let DeliveryMethod = ApolloAPI.Object(
    typename: "DeliveryMethod",
    implementedInterfaces: [ShopifyAdminAPI.Interfaces.Node.self]
  )
}