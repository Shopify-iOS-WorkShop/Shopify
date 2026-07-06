// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// A product category within Shopify's [standardized product taxonomy](https://shopify.github.io/product-taxonomy/releases/unstable/?categoryId=sg-4-17-2-17). Provides hierarchical organization through parent-child relationships, with each category tracking its ancestors, children, and level in the taxonomy tree.
  ///
  /// Categories include attributes specific to their product type and navigation properties like whether they're root, leaf, or archived categories. The taxonomy enables consistent product classification across Shopify and integrated marketplaces.
  static let TaxonomyCategory = ApolloAPI.Object(
    typename: "TaxonomyCategory",
    implementedInterfaces: [ShopifyAdminAPI.Interfaces.Node.self]
  )
}