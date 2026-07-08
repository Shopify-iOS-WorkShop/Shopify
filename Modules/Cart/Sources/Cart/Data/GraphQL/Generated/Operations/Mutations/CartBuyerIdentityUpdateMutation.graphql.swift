// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension CartAPI {
  class CartBuyerIdentityUpdateMutation: GraphQLMutation {
    static let operationName: String = "CartBuyerIdentityUpdate"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation CartBuyerIdentityUpdate($cartId: ID!, $buyerIdentity: CartBuyerIdentityInput!) { cartBuyerIdentityUpdate(cartId: $cartId, buyerIdentity: $buyerIdentity) { __typename cart { __typename ...CartFragment } userErrors { __typename field message code } } }"#,
        fragments: [CartFragment.self, CartLineFragment.self, MoneyFragment.self]
      ))

    public var cartId: ID
    public var buyerIdentity: CartBuyerIdentityInput

    public init(
      cartId: ID,
      buyerIdentity: CartBuyerIdentityInput
    ) {
      self.cartId = cartId
      self.buyerIdentity = buyerIdentity
    }

    public var __variables: Variables? { [
      "cartId": cartId,
      "buyerIdentity": buyerIdentity
    ] }

    struct Data: CartAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { CartAPI.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("cartBuyerIdentityUpdate", CartBuyerIdentityUpdate?.self, arguments: [
          "cartId": .variable("cartId"),
          "buyerIdentity": .variable("buyerIdentity")
        ]),
      ] }

      /// Updates the buyer identity on a [`Cart`](https://shopify.dev/docs/api/storefront/current/objects/Cart), including contact information, location, and checkout preferences. The buyer's country determines [international pricing](https://shopify.dev/docs/storefronts/headless/building-with-the-storefront-api/markets/international-pricing) and should match their shipping address.
      ///
      /// Use this mutation to associate a logged-in customer via access token, set a B2B company location, or configure checkout preferences like delivery method. Preferences prefill checkout fields but don't sync back to the cart if overwritten at checkout.
      ///
      var cartBuyerIdentityUpdate: CartBuyerIdentityUpdate? { __data["cartBuyerIdentityUpdate"] }

      /// CartBuyerIdentityUpdate
      ///
      /// Parent Type: `CartBuyerIdentityUpdatePayload`
      struct CartBuyerIdentityUpdate: CartAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { CartAPI.Objects.CartBuyerIdentityUpdatePayload }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("cart", Cart?.self),
          .field("userErrors", [UserError].self),
        ] }

        /// The updated cart.
        var cart: Cart? { __data["cart"] }
        /// The list of errors that occurred from executing the mutation.
        var userErrors: [UserError] { __data["userErrors"] }

        /// CartBuyerIdentityUpdate.Cart
        ///
        /// Parent Type: `Cart`
        struct Cart: CartAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { CartAPI.Objects.Cart }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(CartFragment.self),
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

        /// CartBuyerIdentityUpdate.UserError
        ///
        /// Parent Type: `CartUserError`
        struct UserError: CartAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { CartAPI.Objects.CartUserError }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("field", [String]?.self),
            .field("message", String.self),
            .field("code", GraphQLEnum<CartAPI.CartErrorCode>?.self),
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