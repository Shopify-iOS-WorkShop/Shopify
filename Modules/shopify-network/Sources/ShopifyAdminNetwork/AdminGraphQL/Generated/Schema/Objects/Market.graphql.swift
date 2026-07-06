// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// A merchant-defined group of buyers identified by conditions such as their
  /// region, retail location, or company location. Each market allows configuration
  /// of a distinct, localized buyer experience. Customizations include, but are
  /// not limited to,
  /// [currency](https://shopify.dev/api/admin-graphql/current/mutations/marketCurrencySettingsUpdate),
  /// [pricing and product availability](https://shopify.dev/apps/internationalization/product-price-lists),
  /// [web presence](https://shopify.dev/api/admin-graphql/current/objects/MarketWebPresence),
  /// and content translations.
  static let Market = ApolloAPI.Object(
    typename: "Market",
    implementedInterfaces: [
      ShopifyAdminAPI.Interfaces.HasMetafieldDefinitions.self,
      ShopifyAdminAPI.Interfaces.HasMetafields.self,
      ShopifyAdminAPI.Interfaces.Node.self
    ]
  )
}