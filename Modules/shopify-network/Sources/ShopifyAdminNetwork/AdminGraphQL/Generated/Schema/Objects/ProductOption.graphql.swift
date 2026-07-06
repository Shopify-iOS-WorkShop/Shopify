// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// A product attribute that customers can choose from, such as "Size", "Color", or "Material". [`Product`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Product) objects use options to define the different variations available for purchase. Each option has a name and a set of possible values that combine to create [`ProductVariant`](https://shopify.dev/docs/api/admin-graphql/latest/objects/ProductVariant) objects.
  ///
  /// The option includes its display position, associated values, and optional [`LinkedMetafield`](https://shopify.dev/docs/api/admin-graphql/latest/objects/LinkedMetafield) for structured data. Options support translations for international selling and track which [`ProductOptionValue`](https://shopify.dev/docs/api/admin-graphql/latest/objects/ProductOptionValue) objects that variants actively use versus unused values that exist without associated variants.
  static let ProductOption = ApolloAPI.Object(
    typename: "ProductOption",
    implementedInterfaces: [
      ShopifyAdminAPI.Interfaces.HasPublishedTranslations.self,
      ShopifyAdminAPI.Interfaces.Node.self
    ]
  )
}