// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension CartAPI.Objects {
  /// A discount allocation [that applies automatically](https://help.shopify.com/manual/discounts/discount-methods/automatic-discounts) to a cart line when configured conditions are met. Unlike [`CartCodeDiscountAllocation`](https://shopify.dev/docs/api/storefront/current/objects/CartCodeDiscountAllocation), automatic discounts don't require customers to enter a code.
  ///
  static let CartAutomaticDiscountAllocation = ApolloAPI.Object(
    typename: "CartAutomaticDiscountAllocation",
    implementedInterfaces: [CartAPI.Interfaces.CartDiscountAllocation.self]
  )
}