// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// An article that contains content, author information, and metadata. Articles belong to a [`Blog`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Blog) and can include HTML-formatted body text, summary text, and an associated image. Merchants publish articles to share content, drive traffic, and engage customers.
  ///
  /// Articles can be organized with tags and published immediately or scheduled for future publication using the [`publishedAt`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Article#field-Article.fields.publishedAt) timestamp. The API manages comments on articles when the blog's comment policy enables them.
  static let Article = ApolloAPI.Object(
    typename: "Article",
    implementedInterfaces: [
      ShopifyAdminAPI.Interfaces.HasEvents.self,
      ShopifyAdminAPI.Interfaces.HasMetafieldDefinitions.self,
      ShopifyAdminAPI.Interfaces.HasMetafields.self,
      ShopifyAdminAPI.Interfaces.HasPublishedTranslations.self,
      ShopifyAdminAPI.Interfaces.Navigable.self,
      ShopifyAdminAPI.Interfaces.Node.self
    ]
  )
}