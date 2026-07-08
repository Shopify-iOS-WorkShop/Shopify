// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// The `Order` object represents a customer's request to purchase one or more products from a store. Use the `Order` object to handle the complete purchase lifecycle from checkout to fulfillment.
  ///
  /// Use the `Order` object when you need to:
  ///
  /// - Display order details on customer account pages or admin dashboards.
  /// - Create orders for phone sales, wholesale customers, or subscription services.
  /// - Update order information like shipping addresses, notes, or fulfillment status.
  /// - Process returns, exchanges, and partial refunds.
  /// - Generate invoices, receipts, and shipping labels.
  ///
  /// The `Order` object serves as the central hub connecting customer information, product details, payment processing, and fulfillment data within the GraphQL Admin API schema.
  ///
  /// > Note:
  /// > Only the last 60 days' worth of orders from a store are accessible from the `Order` object by default. If you want to access older records,
  /// > then you need to [request access to all orders](https://shopify.dev/docs/api/usage/access-scopes#orders-permissions). If your app is granted
  /// > access, then you can add the `read_all_orders`, `read_orders`, and `write_orders` scopes.
  ///
  /// > Caution:
  /// > Only use orders data if it's required for your app's functionality. Shopify will restrict [access to scopes](https://shopify.dev/docs/api/usage/access-scopes#requesting-specific-permissions) for apps that don't have a legitimate use for the associated data.
  ///
  /// Learn more about [building apps for orders and fulfillment](https://shopify.dev/docs/apps/build/orders-fulfillment).
  static let Order = ApolloAPI.Object(
    typename: "Order",
    implementedInterfaces: [
      ShopifyAdminAPI.Interfaces.CommentEventSubject.self,
      ShopifyAdminAPI.Interfaces.HasEvents.self,
      ShopifyAdminAPI.Interfaces.HasLocalizationExtensions.self,
      ShopifyAdminAPI.Interfaces.HasLocalizedFields.self,
      ShopifyAdminAPI.Interfaces.HasMetafieldDefinitions.self,
      ShopifyAdminAPI.Interfaces.HasMetafields.self,
      ShopifyAdminAPI.Interfaces.LegacyInteroperability.self,
      ShopifyAdminAPI.Interfaces.Node.self
    ]
  )
}