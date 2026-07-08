// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// A shipment of one or more items from an [`Order`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Order). Tracks which [`LineItem`](https://shopify.dev/docs/api/admin-graphql/latest/objects/LineItem) objects ship, their quantities, and the shipment's tracking information.
  ///
  /// Includes tracking details such as the carrier, tracking numbers, and URLs. The fulfillment connects to both the original order and any associated [`FulfillmentOrder`](https://shopify.dev/docs/api/admin-graphql/latest/objects/FulfillmentOrder) objects. [`FulfillmentEvent`](https://shopify.dev/docs/api/admin-graphql/latest/objects/FulfillmentEvent) objects record milestones throughout the shipment lifecycle, from creation through delivery.
  ///
  /// Multiple fulfillments can exist for a single order when items either ship separately or from different locations.
  static let Fulfillment = ApolloAPI.Object(
    typename: "Fulfillment",
    implementedInterfaces: [
      ShopifyAdminAPI.Interfaces.LegacyInteroperability.self,
      ShopifyAdminAPI.Interfaces.Node.self
    ]
  )
}