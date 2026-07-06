// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// A recurring billing agreement that associates an [`App`](https://shopify.dev/docs/api/admin-graphql/latest/objects/App) with a merchant's shop. Each subscription contains one or more [`AppSubscriptionLineItem`](https://shopify.dev/docs/api/admin-graphql/latest/objects/AppSubscriptionLineItem) objects that define the pricing structure. The pricing structure can include recurring charges, usage-based pricing, or both.
  ///
  /// The subscription tracks billing details including the current period end date, trial days, and [`AppSubscriptionStatus`](https://shopify.dev/docs/api/admin-graphql/latest/enums/AppSubscriptionStatus). 
  ///
  /// Merchants must approve subscriptions through a [confirmation URL](https://shopify.dev/docs/api/admin-graphql/latest/mutations/appSubscriptionCreate#returns-confirmationUrl) before billing begins. Test subscriptions allow developers to verify billing flows without actual charges.
  ///
  /// Learn more about [subscription billing](https://shopify.dev/docs/apps/launch/billing/subscription-billing) and [testing charges](https://shopify.dev/docs/apps/launch/billing/managed-pricing#test-charges).
  static let AppSubscription = ApolloAPI.Object(
    typename: "AppSubscription",
    implementedInterfaces: [ShopifyAdminAPI.Interfaces.Node.self]
  )
}