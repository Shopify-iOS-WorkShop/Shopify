// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// A physical mailing address. For example, a [`Customer`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Customer)'s default address and an [`Order`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Order)'s billing address are both mailing addresses. Stores standard address components, customer name information, and company details.
  ///
  /// The address includes geographic coordinates ([`latitude`](https://shopify.dev/docs/api/admin-graphql/latest/objects/MailingAddress#field-MailingAddress.fields.latitude) and [`longitude`](https://shopify.dev/docs/api/admin-graphql/latest/objects/MailingAddress#field-MailingAddress.fields.longitude)). You can format addresses for display using the [`formatted`](https://shopify.dev/docs/api/admin-graphql/latest/objects/MailingAddress#field-MailingAddress.fields.formatted) field with options to include or exclude name and company information.
  static let MailingAddress = ApolloAPI.Object(
    typename: "MailingAddress",
    implementedInterfaces: [ShopifyAdminAPI.Interfaces.Node.self]
  )
}