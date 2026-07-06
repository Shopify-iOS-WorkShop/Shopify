// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// A tracking event that records the status and location of a fulfillment at a specific point in time. Each event captures details such as the [status](https://shopify.dev/docs/api/admin-graphql/latest/objects/FulfillmentEvent#field-FulfillmentEvent.fields.status) (for example, in transit, out for delivery, delivered) and any [messages](https://shopify.dev/docs/api/admin-graphql/latest/objects/FulfillmentEvent#field-FulfillmentEvent.fields.message) associated with the event.
  ///
  /// Fulfillment events provide a chronological history of a package's journey from shipment to delivery. They include timestamps, geographic coordinates, and estimated delivery dates to track fulfillment progress.
  static let FulfillmentEvent = ApolloAPI.Object(
    typename: "FulfillmentEvent",
    implementedInterfaces: [ShopifyAdminAPI.Interfaces.Node.self]
  )
}