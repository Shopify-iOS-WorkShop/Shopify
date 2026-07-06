// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// Associates an order line item with the quantities that require fulfillment as part of a fulfillment order. Each Fulfillment Order Line Item object tracks the total quantity to fulfill and the remaining quantity yet to be fulfilled, along with details about the line item being fulfilled and pricing information.
  ///
  /// The line item provides additional fulfillment data including whether the item requires shipping. Financial summaries show pricing details with discounts applied, while warning messages alert merchants to any issues that might affect fulfillment.
  static let FulfillmentOrderLineItem = ApolloAPI.Object(
    typename: "FulfillmentOrderLineItem",
    implementedInterfaces: [ShopifyAdminAPI.Interfaces.Node.self]
  )
}