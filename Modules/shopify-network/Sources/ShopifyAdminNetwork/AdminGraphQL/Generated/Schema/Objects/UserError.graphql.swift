// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// An error in the input of a mutation. Mutations return `UserError` objects to indicate validation failures, such as invalid field values or business logic violations, that prevent the operation from completing.
  static let UserError = ApolloAPI.Object(
    typename: "UserError",
    implementedInterfaces: [ShopifyAdminAPI.Interfaces.DisplayableError.self]
  )
}