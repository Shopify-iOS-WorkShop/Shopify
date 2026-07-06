// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI {
  /// The input fields for a LocalizedFieldInput.
  struct LocalizedFieldInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      key: GraphQLEnum<LocalizedFieldKey>,
      value: String
    ) {
      __data = InputDict([
        "key": key,
        "value": value
      ])
    }

    /// The key for the localized field.
    public var key: GraphQLEnum<LocalizedFieldKey> {
      get { __data["key"] }
      set { __data["key"] = newValue }
    }

    /// The localized field value.
    public var value: String {
      get { __data["value"] }
      set { __data["value"] = newValue }
    }
  }

}