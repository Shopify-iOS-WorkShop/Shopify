// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension CartAPI.Unions {
  /// A [`ProductVariant`](https://shopify.dev/docs/api/storefront/current/objects/ProductVariant) that a buyer intends to purchase at checkout.
  ///
  static let Merchandise = Union(
    name: "Merchandise",
    possibleTypes: [CartAPI.Objects.ProductVariant.self]
  )
}