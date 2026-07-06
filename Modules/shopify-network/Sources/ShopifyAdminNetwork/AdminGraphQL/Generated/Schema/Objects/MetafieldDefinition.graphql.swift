// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// Defines the structure, validation rules, and permissions for [`Metafield`](https://shopify.dev/docs/api/admin-graphql/current/objects/Metafield) objects attached to a specific owner type. Each definition establishes a schema that metafields must follow, including the data type and validation constraints.
  ///
  /// The definition controls access permissions across different APIs, determines whether the metafield can be used for filtering or as a collection condition, and can be constrained to specific resource subtypes.
  static let MetafieldDefinition = ApolloAPI.Object(
    typename: "MetafieldDefinition",
    implementedInterfaces: [ShopifyAdminAPI.Interfaces.Node.self]
  )
}