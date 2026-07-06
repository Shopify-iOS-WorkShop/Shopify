// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// The `MediaImage` object represents an image hosted on Shopify's
  /// [content delivery network (CDN)](https://shopify.dev/docs/storefronts/themes/best-practices/performance/platform#shopify-cdn).
  /// Shopify CDN is a content system that serves as the primary way to store,
  /// manage, and deliver visual content for products, variants, and other resources across the Shopify platform.
  ///
  /// The `MediaImage` object provides information to:
  ///
  /// - Store and display product and variant images across online stores, admin interfaces, and mobile apps.
  /// - Retrieve visual branding elements, including logos, banners, favicons, and background images in checkout flows.
  /// - Retrieve signed URLs for secure, time-limited access to original image files.
  ///
  /// Each `MediaImage` object provides both the processed image data (with automatic optimization and CDN delivery)
  /// and access to the original source file. The image processing is handled asynchronously, so images
  /// might not be immediately available after upload. The
  /// [`status`](https://shopify.dev/docs/api/admin-graphql/latest/objects/mediaimage#field-MediaImage.fields.status)
  /// field indicates when processing is complete and the image is ready for use.
  ///
  /// The `MediaImage` object implements the [`Media`](https://shopify.dev/docs/api/admin-graphql/latest/interfaces/Media)
  /// interface alongside other media types, like videos and 3D models.
  ///
  /// Learn about
  /// managing media for [products](https://shopify.dev/docs/apps/build/online-store/product-media),
  /// [product variants](https://shopify.dev/docs/apps/build/online-store/product-variant-media), and
  /// [asynchronous media management](https://shopify.dev/docs/apps/build/graphql/migrate/new-product-model/product-model-components#asynchronous-media-management).
  static let MediaImage = ApolloAPI.Object(
    typename: "MediaImage",
    implementedInterfaces: [
      ShopifyAdminAPI.Interfaces.File.self,
      ShopifyAdminAPI.Interfaces.HasMetafields.self,
      ShopifyAdminAPI.Interfaces.Media.self,
      ShopifyAdminAPI.Interfaces.Node.self
    ]
  )
}