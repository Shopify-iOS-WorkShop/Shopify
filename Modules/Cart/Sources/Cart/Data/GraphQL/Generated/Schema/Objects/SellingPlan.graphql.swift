// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension CartAPI.Objects {
  /// Represents deferred or recurring purchase options for [products](https://shopify.dev/docs/api/storefront/current/objects/Product) and [product variants](https://shopify.dev/docs/api/storefront/current/objects/ProductVariant), such as subscriptions, pre-orders, or try-before-you-buy. Each selling plan belongs to a [`SellingPlanGroup`](https://shopify.dev/docs/api/storefront/current/objects/SellingPlanGroup) and defines billing, pricing, inventory, and delivery policies.
  ///
  nonisolated static let SellingPlan = ApolloAPI.Object(
    typename: "SellingPlan",
    implementedInterfaces: [CartAPI.Interfaces.HasMetafields.self],
    keyFields: nil
  )
}