// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension CartAPI {
  class CartCreateMutation: GraphQLMutation {
    static let operationName: String = "CartCreate"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation CartCreate($input: CartInput!) { cartCreate(input: $input) { __typename cart { __typename ...CartFragment } userErrors { __typename field message code } } }"#,
        fragments: [CartFragment.self, CartLineFragment.self, MoneyFragment.self]
      ))

    public var input: CartInput

    public init(input: CartInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    struct Data: CartAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { CartAPI.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("cartCreate", CartCreate?.self, arguments: ["input": .variable("input")]),
      ] }

      /// Creates a new [`Cart`](https://shopify.dev/docs/api/storefront/current/objects/Cart) for a buyer session. You can optionally initialize the cart with merchandise lines, discount codes, gift card codes, buyer identity for international pricing, and custom attributes.
      ///
      /// The returned cart includes a `checkoutUrl` that directs the buyer to complete their purchase.
      ///
      var cartCreate: CartCreate? { __data["cartCreate"] }

      /// CartCreate
      ///
      /// Parent Type: `CartCreatePayload`
      struct CartCreate: CartAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { CartAPI.Objects.CartCreatePayload }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("cart", Cart?.self),
          .field("userErrors", [UserError].self),
        ] }

        /// The new cart.
        var cart: Cart? { __data["cart"] }
        /// The list of errors that occurred from executing the mutation.
        var userErrors: [UserError] { __data["userErrors"] }

        /// CartCreate.Cart
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

        /// CartCreate.UserError
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