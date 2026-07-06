// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// A connection between a Shopify shop and an external selling platform that supports product syndication and optionally order ingestion. Each channel binds a merchant's account on a specific platform — such as Amazon, eBay, Google, or a point-of-sale system — to the shop, establishing the publishing destination for product feeds.
  ///
  /// Sales Channel applications use [`channelCreate`](https://shopify.dev/docs/api/admin-graphql/latest/mutations/channelCreate) to establish channels after merchant authentication, and can manage multiple channel connections per app. Each channel is bound to a channel specification that declares the platform's regional coverage, capabilities, and requirements.
  ///
  /// Use channels to manage where catalog items are syndicated, track publication status across platforms, and control [`Product`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Product) visibility for different selling destinations.
  static let Channel = ApolloAPI.Object(
    typename: "Channel",
    implementedInterfaces: [ShopifyAdminAPI.Interfaces.Node.self]
  )
}