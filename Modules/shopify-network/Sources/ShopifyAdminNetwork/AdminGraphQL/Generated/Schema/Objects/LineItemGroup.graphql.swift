// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// The information for [line items](https://shopify.dev/docs/api/admin-graphql/latest/objects/LineItem) that are part of a bundle. When a bundle is purchased, each component line item references its [`LineItemGroup`](https://shopify.dev/docs/api/admin-graphql/latest/objects/LineItemGroup) through the [`lineItemGroup`](https://shopify.dev/docs/api/admin-graphql/latest/objects/LineItem#field-lineItemGroup) field to maintain the relationship with the bundle.
  ///
  /// The parent bundle's product, variant, and custom attributes enable apps to group and display bundle components in order management systems, transactional emails, and other contexts where understanding the bundle structure is needed.
  ///
  /// Learn more about [product bundles](https://shopify.dev/docs/apps/build/product-merchandising/bundles).
  static let LineItemGroup = ApolloAPI.Object(
    typename: "LineItemGroup",
    implementedInterfaces: [ShopifyAdminAPI.Interfaces.Node.self]
  )
}