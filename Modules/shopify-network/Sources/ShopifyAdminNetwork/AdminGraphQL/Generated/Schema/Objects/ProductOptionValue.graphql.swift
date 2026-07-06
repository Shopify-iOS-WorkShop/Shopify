// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// A specific value for a [`ProductOption`](https://shopify.dev/docs/api/admin-graphql/latest/objects/ProductOption), such as "Red" or "Blue" for a "Color" option. Each value can be assigned to [`ProductVariant`](https://shopify.dev/docs/api/admin-graphql/latest/objects/ProductVariant) objects to create different versions of a [`Product`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Product).
  ///
  /// The value tracks whether any variants currently use it through the [`hasVariants`](https://shopify.dev/docs/api/admin-graphql/latest/objects/ProductOptionValue#field-hasVariants) field. Values can include visual representations through swatches that display colors or images. When linked to a [`Metafield`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Metafield), the [`linkedMetafieldValue`](https://shopify.dev/docs/api/admin-graphql/latest/objects/ProductOptionValue#field-linkedMetafieldValue) provides additional structured data for the option value.
  static let ProductOptionValue = ApolloAPI.Object(
    typename: "ProductOptionValue",
    implementedInterfaces: [
      ShopifyAdminAPI.Interfaces.HasPublishedTranslations.self,
      ShopifyAdminAPI.Interfaces.Node.self
    ]
  )
}