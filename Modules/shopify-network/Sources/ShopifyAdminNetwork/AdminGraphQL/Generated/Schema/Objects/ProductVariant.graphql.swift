// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// The `ProductVariant` object represents a version of a
  /// [product](https://shopify.dev/docs/api/admin-graphql/latest/objects/Product)
  /// that comes in more than one [option](https://shopify.dev/docs/api/admin-graphql/latest/objects/ProductOption),
  /// such as size or color. For example, if a merchant sells t-shirts with options for size and color, then a small,
  /// blue t-shirt would be one product variant and a large, blue t-shirt would be another.
  ///
  /// Use the `ProductVariant` object to manage the full lifecycle and configuration of a product's variants. Common
  /// use cases for using the `ProductVariant` object include:
  ///
  /// - Tracking inventory for each variant
  /// - Setting unique prices for each variant
  /// - Assigning barcodes and SKUs to connect variants to fulfillment services
  /// - Attaching variant-specific images and media
  /// - Setting delivery and tax requirements
  /// - Supporting product bundles, subscriptions, and selling plans
  ///
  /// A `ProductVariant` is associated with a parent
  /// [`Product`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Product) object.
  /// `ProductVariant` serves as the central link between a product's merchandising configuration, inventory,
  /// pricing, fulfillment, and sales channels within the GraphQL Admin API schema. Each variant
  /// can reference other GraphQL types such as:
  ///
  /// - [`InventoryItem`](https://shopify.dev/docs/api/admin-graphql/latest/objects/InventoryItem): Used for inventory tracking
  /// - [`Image`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Image): Used for variant-specific images
  /// - [`SellingPlanGroup`](https://shopify.dev/docs/api/admin-graphql/latest/objects/SellingPlanGroup): Used for subscriptions and selling plans
  ///
  /// Learn more about [Shopify's product model](https://shopify.dev/docs/apps/build/graphql/migrate/new-product-model/product-model-components).
  static let ProductVariant = ApolloAPI.Object(
    typename: "ProductVariant",
    implementedInterfaces: [
      ShopifyAdminAPI.Interfaces.HasEvents.self,
      ShopifyAdminAPI.Interfaces.HasMetafieldDefinitions.self,
      ShopifyAdminAPI.Interfaces.HasMetafields.self,
      ShopifyAdminAPI.Interfaces.HasPublishedTranslations.self,
      ShopifyAdminAPI.Interfaces.LegacyInteroperability.self,
      ShopifyAdminAPI.Interfaces.Navigable.self,
      ShopifyAdminAPI.Interfaces.Node.self
    ]
  )
}