// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAPI.Interfaces {
  /// A common interface for querying discount allocations regardless of how the discount was applied ([automatic](https://help.shopify.com/manual/discounts/discount-methods/automatic-discounts), [code](https://help.shopify.com/manual/discounts/discount-methods/discount-codes), or custom). Each implementation represents a different discount source.
  ///
  /// Tracks how a discount distributes across [cart lines](https://shopify.dev/docs/api/storefront/current/objects/CartLine). Each allocation includes the [`CartDiscountApplication`](https://shopify.dev/docs/api/storefront/current/objects/CartDiscountApplication) details, the discounted amount, and whether the discount targets line items or shipping.
  ///
  static let CartDiscountAllocation = Interface(name: "CartDiscountAllocation")
}