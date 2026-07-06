// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// A customer's session on the online store. Tracks how the [`Customer`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Customer) arrived at the store, including the landing page, referral source, and any associated marketing campaigns.
  ///
  /// The visit captures attribution data such as [`UTMParameters`](https://shopify.dev/docs/api/admin-graphql/latest/objects/UTMParameters), referral codes, and the [`MarketingEvent`](https://shopify.dev/docs/api/admin-graphql/latest/objects/MarketingEvent) that drove the session. This information helps merchants understand which marketing efforts successfully bring customers to their store.
  static let CustomerVisit = ApolloAPI.Object(
    typename: "CustomerVisit",
    implementedInterfaces: [
      ShopifyAdminAPI.Interfaces.CustomerMoment.self,
      ShopifyAdminAPI.Interfaces.Node.self
    ]
  )
}