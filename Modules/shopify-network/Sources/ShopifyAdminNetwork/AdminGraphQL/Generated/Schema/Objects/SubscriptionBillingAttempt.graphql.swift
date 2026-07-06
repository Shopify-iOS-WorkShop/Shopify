// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// A record of an execution of the subscription billing process. Billing attempts use idempotency keys to avoid duplicate order creation.
  ///
  /// When a billing attempt completes successfully, it creates an [`Order`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Order). The attempt includes associated payment transactions and any errors that occur during billing. If 3D Secure authentication is required, the `nextActionUrl` field provides the redirect URL for customer verification.
  static let SubscriptionBillingAttempt = ApolloAPI.Object(
    typename: "SubscriptionBillingAttempt",
    implementedInterfaces: [ShopifyAdminAPI.Interfaces.Node.self]
  )
}