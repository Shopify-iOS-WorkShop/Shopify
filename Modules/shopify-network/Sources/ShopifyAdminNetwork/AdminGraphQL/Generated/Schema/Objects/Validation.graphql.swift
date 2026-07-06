// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// A server-side validation that enforces business rules before customers complete their purchases. Each validation links to a [`ShopifyFunction`](https://shopify.dev/docs/api/functions/latest/cart-and-checkout-validation) that implements the validation logic.
  ///
  /// Validations run on Shopify's servers and are enforced throughout the checkout process. Validation errors always block checkout progress. The `blockOnFailure` setting determines whether runtime exceptions, like timeouts, also block checkout. Tracks runtime exception history for the validation function and supports custom data through [`Metafield`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Metafield) objects.
  static let Validation = ApolloAPI.Object(
    typename: "Validation",
    implementedInterfaces: [
      ShopifyAdminAPI.Interfaces.HasMetafieldDefinitions.self,
      ShopifyAdminAPI.Interfaces.HasMetafields.self,
      ShopifyAdminAPI.Interfaces.Node.self
    ]
  )
}