// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// A user account that can access the Shopify admin to manage store operations. Includes personal information and account status.
  ///
  /// You can assign staff members to [`CompanyLocation`](https://shopify.dev/docs/api/admin-graphql/latest/objects/CompanyLocation) objects for [B2B operations](https://shopify.dev/docs/apps/build/b2b), limiting their actions to those locations.
  static let StaffMember = ApolloAPI.Object(
    typename: "StaffMember",
    implementedInterfaces: [ShopifyAdminAPI.Interfaces.Node.self]
  )
}