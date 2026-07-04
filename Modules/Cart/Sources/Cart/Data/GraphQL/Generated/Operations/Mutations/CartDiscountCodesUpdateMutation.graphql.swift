// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

extension CartAPI {
  nonisolated struct CartDiscountCodesUpdateMutation: GraphQLMutation {
    static let operationName: String = "CartDiscountCodesUpdate"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation CartDiscountCodesUpdate($cartId: ID!, $discountCodes: [String!]!) { cartDiscountCodesUpdate(cartId: $cartId, discountCodes: $discountCodes) { __typename cart { __typename ...CartFragment } userErrors { __typename field message code } } }"#,
        fragments: [CartFragment.self, CartLineFragment.self, MoneyFragment.self]
      ))

    public var cartId: ID
    public var discountCodes: [String]

    public init(
      cartId: ID,
      discountCodes: [String]
    ) {
      self.cartId = cartId
      self.discountCodes = discountCodes
    }

    @_spi(Unsafe) public var __variables: Variables? { [
      "cartId": cartId,
      "discountCodes": discountCodes
    ] }

    nonisolated struct Data: CartAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { CartAPI.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("cartDiscountCodesUpdate", CartDiscountCodesUpdate?.self, arguments: [
          "cartId": .variable("cartId"),
          "discountCodes": .variable("discountCodes")
        ]),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        CartDiscountCodesUpdateMutation.Data.self
      ] }

      /// Updates the discount codes applied to a [`Cart`](https://shopify.dev/docs/api/storefront/current/objects/Cart). This mutation replaces all existing discount codes with the provided list, so pass an empty array to remove all codes. Discount codes are case-insensitive.
      ///
      /// After updating, check each [`CartDiscountCode`](https://shopify.dev/docs/api/storefront/current/objects/CartDiscountCode) in the cart's [`discountCodes`](https://shopify.dev/docs/api/storefront/current/objects/Cart#field-Cart.fields.discountCodes) field to see whether the code is applicable to the cart's current contents.
      ///
      var cartDiscountCodesUpdate: CartDiscountCodesUpdate? { __data["cartDiscountCodesUpdate"] }

      /// CartDiscountCodesUpdate
      ///
      /// Parent Type: `CartDiscountCodesUpdatePayload`
      nonisolated struct CartDiscountCodesUpdate: CartAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { CartAPI.Objects.CartDiscountCodesUpdatePayload }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("cart", Cart?.self),
          .field("userErrors", [UserError].self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          CartDiscountCodesUpdateMutation.Data.CartDiscountCodesUpdate.self
        ] }

        /// The updated cart.
        var cart: Cart? { __data["cart"] }
        /// The list of errors that occurred from executing the mutation.
        var userErrors: [UserError] { __data["userErrors"] }

        /// CartDiscountCodesUpdate.Cart
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
            CartDiscountCodesUpdateMutation.Data.CartDiscountCodesUpdate.Cart.self,
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

        /// CartDiscountCodesUpdate.UserError
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
            CartDiscountCodesUpdateMutation.Data.CartDiscountCodesUpdate.UserError.self
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