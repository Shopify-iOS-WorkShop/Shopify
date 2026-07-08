// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI {
  /// The input fields representing the components of a line item.
  struct DraftOrderLineItemComponentInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      variantId: GraphQLNullable<ID> = nil,
      quantity: Int,
      uuid: GraphQLNullable<String> = nil
    ) {
      __data = InputDict([
        "variantId": variantId,
        "quantity": quantity,
        "uuid": uuid
      ])
    }

    /// The ID of the product variant corresponding to the component.
    public var variantId: GraphQLNullable<ID> {
      get { __data["variantId"] }
      set { __data["variantId"] = newValue }
    }

    /// The quantity of the component.
    public var quantity: Int {
      get { __data["quantity"] }
      set { __data["quantity"] = newValue }
    }

    /// The UUID of the component. Must be unique and consistent across requests.
    /// This field is mandatory in order to manipulate drafts with parent line items.
    public var uuid: GraphQLNullable<String> {
      get { __data["uuid"] }
      set { __data["uuid"] = newValue }
    }
  }

}