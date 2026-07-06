// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// A group of [customers](https://shopify.dev/docs/api/admin-graphql/latest/objects/Customer) that meet specific criteria defined through [ShopifyQL query](https://shopify.dev/docs/api/shopifyql/segment-query-language-reference) conditions. Common use cases for segments include customer analytics, targeted marketing campaigns, and automated discount eligibility.
  ///
  /// The segment's [`query`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Segment#field-query) field contains ShopifyQL conditions that determine membership, such as purchase history, location, or engagement patterns. Tracks when the segment was created with [`creationDate`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Segment#field-creationDate) and when it was last modified with [`lastEditDate`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Segment#field-lastEditDate).
  static let Segment = ApolloAPI.Object(
    typename: "Segment",
    implementedInterfaces: [ShopifyAdminAPI.Interfaces.Node.self]
  )
}