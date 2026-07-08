// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension CartAPI {
  class CartLinesAddMutation: GraphQLMutation {
    static let operationName: String = "CartLinesAdd"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation CartLinesAdd($cartId: ID!, $lines: [CartLineInput!]!) { cartLinesAdd(cartId: $cartId, lines: $lines) { __typename cart { __typename ...CartFragment } userErrors { __typename field message code } } }"#,
        fragments: [CartFragment.self, CartLineFragment.self, MoneyFragment.self]
      ))

    public var cartId: ID
    public var lines: [CartLineInput]

    public init(
      cartId: ID,
      lines: [CartLineInput]
    ) {
      self.cartId = cartId
      self.lines = lines
    }

    public var __variables: Variables? { [
      "cartId": cartId,
      "lines": lines
    ] }

    struct Data: CartAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { CartAPI.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("cartLinesAdd", CartLinesAdd?.self, arguments: [
          "cartId": .variable("cartId"),
          "lines": .variable("lines")
        ]),
      ] }

      /// Adds one or more merchandise lines to an existing [`Cart`](https://shopify.dev/docs/api/storefront/current/objects/Cart). Each line specifies the [product variant](https://shopify.dev/docs/api/storefront/current/objects/ProductVariant) to purchase. Quantity defaults to `1` if not provided.
      ///
      /// You can add up to 250 lines in a single request. Use [`CartLineInput`](https://shopify.dev/docs/api/storefront/current/input-objects/CartLineInput) to configure each line's merchandise, quantity, selling plan, custom attributes, and any parent relationships for nested line items such as warranties or add-ons.
      ///
      var cartLinesAdd: CartLinesAdd? { __data["cartLinesAdd"] }

      /// CartLinesAdd
      ///
      /// Parent Type: `CartLinesAddPayload`
      struct CartLinesAdd: CartAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { CartAPI.Objects.CartLinesAddPayload }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("cart", Cart?.self),
          .field("userErrors", [UserError].self),
        ] }

        /// The updated cart.
        var cart: Cart? { __data["cart"] }
        /// The list of errors that occurred from executing the mutation.
        var userErrors: [UserError] { __data["userErrors"] }

        /// CartLinesAdd.Cart
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

        /// CartLinesAdd.UserError
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