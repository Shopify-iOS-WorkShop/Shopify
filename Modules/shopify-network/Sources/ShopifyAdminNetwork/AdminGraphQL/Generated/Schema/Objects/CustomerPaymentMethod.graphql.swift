// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// A customer's saved payment method. Stores the payment instrument details and billing information for recurring charges.
  ///
  /// The payment method supports types included in the [`CustomerPaymentInstrument`](https://shopify.dev/docs/api/admin-graphql/latest/unions/CustomerPaymentInstrument) union.
  static let CustomerPaymentMethod = ApolloAPI.Object(
    typename: "CustomerPaymentMethod",
    implementedInterfaces: [ShopifyAdminAPI.Interfaces.Node.self]
  )
}