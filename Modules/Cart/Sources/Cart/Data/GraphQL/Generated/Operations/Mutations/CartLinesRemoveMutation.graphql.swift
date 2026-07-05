// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

extension CartAPI {
  nonisolated struct CartLinesRemoveMutation: GraphQLMutation {
    static let operationName: String = "CartLinesRemove"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation CartLinesRemove($cartId: ID!, $lineIds: [ID!]!) { cartLinesRemove(cartId: $cartId, lineIds: $lineIds) { __typename cart { __typename ...CartFragment } userErrors { __typename field message code } } }"#,
        fragments: [CartFragment.self, CartLineFragment.self, MoneyFragment.self]
      ))

    public var cartId: ID
    public var lineIds: [ID]

    public init(
      cartId: ID,
      lineIds: [ID]
    ) {
      self.cartId = cartId
      self.lineIds = lineIds
    }

    @_spi(Unsafe) public var __variables: Variables? { [
      "cartId": cartId,
      "lineIds": lineIds
    ] }

    nonisolated struct Data: CartAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { CartAPI.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("cartLinesRemove", CartLinesRemove?.self, arguments: [
          "cartId": .variable("cartId"),
          "lineIds": .variable("lineIds")
        ]),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        CartLinesRemoveMutation.Data.self
      ] }

      /// Removes one or more merchandise lines from a [`Cart`](https://shopify.dev/docs/api/storefront/current/objects/Cart). Accepts up to 250 line IDs per request. Returns the updated cart along with any errors or warnings.
      ///
      var cartLinesRemove: CartLinesRemove? { __data["cartLinesRemove"] }

      /// CartLinesRemove
      ///
      /// Parent Type: `CartLinesRemovePayload`
      nonisolated struct CartLinesRemove: CartAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { CartAPI.Objects.CartLinesRemovePayload }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("cart", Cart?.self),
          .field("userErrors", [UserError].self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          CartLinesRemoveMutation.Data.CartLinesRemove.self
        ] }

        /// The updated cart.
        var cart: Cart? { __data["cart"] }
        /// The list of errors that occurred from executing the mutation.
        var userErrors: [UserError] { __data["userErrors"] }

        /// CartLinesRemove.Cart
        ///
        /// Parent Type: `Cart`
        nonisolated struct Cart: CartAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { CartAPI.Objects.Cart }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(CartFragment.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            CartLinesRemoveMutation.Data.CartLinesRemove.Cart.self,
            CartFragment.self
          ] }

          /// A globally-unique ID.
          var id: CartAPI.ID { __data["id"] }
          /// The URL of the checkout for the cart.
          var checkoutUrl: CartAPI.URL { __data["checkoutUrl"] }
          /// The total number of items in the cart.
          var totalQuantity: Int { __data["totalQuantity"] }
          /// A note that's associated with the cart. For example, the note can be a personalized message to the buyer.
          var note: String? { __data["note"] }
          /// A list of lines containing information about the items the customer intends to purchase.
          var lines: Lines { __data["lines"] }
          /// The estimated costs that the buyer will pay at checkout. The costs are subject to change and changes will be reflected at checkout. The `cost` field uses the `buyerIdentity` field to determine [international pricing](https://shopify.dev/custom-storefronts/internationalization/international-pricing).
          var cost: Cost { __data["cost"] }
          /// The case-insensitive discount codes that the customer added at checkout.
          var discountCodes: [DiscountCode] { __data["discountCodes"] }
          /// Information about the buyer that's interacting with the cart.
          var buyerIdentity: BuyerIdentity { __data["buyerIdentity"] }

          struct Fragments: FragmentContainer {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            var cartFragment: CartFragment { _toFragment() }
          }

          typealias Lines = CartFragment.Lines

          typealias Cost = CartFragment.Cost

          typealias DiscountCode = CartFragment.DiscountCode

          typealias BuyerIdentity = CartFragment.BuyerIdentity
        }

        /// CartLinesRemove.UserError
        ///
        /// Parent Type: `CartUserError`
        nonisolated struct UserError: CartAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { CartAPI.Objects.CartUserError }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("field", [String]?.self),
            .field("message", String.self),
            .field("code", GraphQLEnum<CartAPI.CartErrorCode>?.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            CartLinesRemoveMutation.Data.CartLinesRemove.UserError.self
          ] }

          /// The path to the input field that caused the error.
          var field: [String]? { __data["field"] }
          /// The error message.
          var message: String { __data["message"] }
          /// The error code.
          var code: GraphQLEnum<CartAPI.CartErrorCode>? { __data["code"] }
        }
      }
    }
  }

}