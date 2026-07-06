// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// A specific selling surface within a [sales channel](https://shopify.dev/docs/apps/build/sales-channels) platform. A channel definition identifies where products can be sold. Definitions can represent entire platforms (like Facebook or TikTok) or specific sales channels within those platforms, such as Instagram Shops, Instagram Shopping, or TikTok Live.
  ///
  /// Each definition includes the parent [`Channel`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Channel) name and subchannel name to indicate the selling surface hierarchy.
  static let ChannelDefinition = ApolloAPI.Object(
    typename: "ChannelDefinition",
    implementedInterfaces: [ShopifyAdminAPI.Interfaces.Node.self]
  )
}