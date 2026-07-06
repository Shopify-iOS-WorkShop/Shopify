// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// A transaction that contributes to a Shopify Payments account balance. Records money movement from charges, refunds, payouts, adjustments, or other payment activities. Includes the gross amount, processing fees, and resulting net amount that affects the account balance. Links to the source of the transaction and associated [`ShopifyPaymentsPayout`](https://shopify.dev/docs/api/admin-graphql/latest/objects/ShopifyPaymentsPayout) details, with optional references to [`Order`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Order) objects or adjustment reasons when applicable.
  static let ShopifyPaymentsBalanceTransaction = ApolloAPI.Object(
    typename: "ShopifyPaymentsBalanceTransaction",
    implementedInterfaces: [ShopifyAdminAPI.Interfaces.Node.self]
  )
}