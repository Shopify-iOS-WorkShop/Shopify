// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// Identifies the [sales channel](https://shopify.dev/docs/apps/build/sales-channels) and [`App`](https://shopify.dev/docs/api/admin-graphql/latest/objects/App) from which an [`Order`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Order) originated. Provides attribution details such as the specific platform (Facebook Marketplace, Instagram Shopping) or marketplace where the order was placed.
  ///
  /// Links to the app that manages the channel and optional [`ChannelDefinition`](https://shopify.dev/docs/api/admin-graphql/latest/objects/ChannelDefinition) details that specify the exact sub-channel or selling surface.
  static let ChannelInformation = ApolloAPI.Object(
    typename: "ChannelInformation",
    implementedInterfaces: [ShopifyAdminAPI.Interfaces.Node.self]
  )
}