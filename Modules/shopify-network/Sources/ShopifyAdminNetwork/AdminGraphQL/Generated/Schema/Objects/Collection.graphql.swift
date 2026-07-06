// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// The `Collection` object represents a group of [products](https://shopify.dev/docs/api/admin-graphql/latest/objects/Product)
  /// that merchants can organize to make their stores easier to browse and help customers find related products.
  /// Collections serve as the primary way to categorize and display products across
  /// [online stores](https://shopify.dev/docs/apps/build/online-store),
  /// [sales channels](https://shopify.dev/docs/apps/build/sales-channels), and marketing campaigns.
  ///
  /// The `Collection` object provides information to:
  ///
  /// - Organize products by category, season, or promotion.
  /// - Automate product grouping using rules (for example, by tag, type, or price).
  /// - Configure product sorting and display order (for example, alphabetical, best-selling, price, or manual).
  /// - Manage collection visibility and publication across sales channels.
  /// - Add rich descriptions, images, and metadata to enhance discovery.
  ///
  /// > Note:
  /// > Collections are unpublished by default. To make them available to customers,
  /// use the [`publishablePublish`](https://shopify.dev/docs/api/admin-graphql/latest/mutations/publishablePublish)
  /// mutation after creation.
  ///
  /// Collections can be displayed in a store with Shopify's theme system through [Liquid templates](https://shopify.dev/docs/storefronts/themes/architecture/templates/collection)
  /// and can be customized with [template suffixes](https://shopify.dev/docs/storefronts/themes/architecture/templates/alternate-templates)
  /// for unique layouts. They also support advanced features like translated content, resource feedback,
  /// and contextual publication for location-based catalogs.
  ///
  /// Learn about [using metafields with collection conditions](https://shopify.dev/docs/apps/build/custom-data/metafields/use-metafield-capabilities).
  static let Collection = ApolloAPI.Object(
    typename: "Collection",
    implementedInterfaces: [
      ShopifyAdminAPI.Interfaces.HasEvents.self,
      ShopifyAdminAPI.Interfaces.HasMetafieldDefinitions.self,
      ShopifyAdminAPI.Interfaces.HasMetafields.self,
      ShopifyAdminAPI.Interfaces.HasPublishedTranslations.self,
      ShopifyAdminAPI.Interfaces.Node.self,
      ShopifyAdminAPI.Interfaces.Publishable.self
    ]
  )
}