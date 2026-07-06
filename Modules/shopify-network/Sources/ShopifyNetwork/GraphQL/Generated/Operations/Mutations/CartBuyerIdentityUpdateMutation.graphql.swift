// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension ShopifyAPI {
  class CartBuyerIdentityUpdateMutation: GraphQLMutation {
    public static let operationName: String = "CartBuyerIdentityUpdate"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
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

    public struct Data: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("cartBuyerIdentityUpdate", CartBuyerIdentityUpdate?.self, arguments: [
          "cartId": .variable("cartId"),
          "buyerIdentity": .variable("buyerIdentity")
        ]),
      ] }

      /// Updates the buyer identity on a [`Cart`](https://shopify.dev/docs/api/storefront/current/objects/Cart), including contact information, location, and checkout preferences. The buyer's country determines [international pricing](https://shopify.dev/docs/storefronts/headless/building-with-the-storefront-api/markets/international-pricing) and should match their shipping address.
      ///
      /// Use this mutation to associate a logged-in customer via access token, set a B2B company location, or configure checkout preferences like delivery method. Preferences prefill checkout fields but don't sync back to the cart if overwritten at checkout.
      ///
      public var cartBuyerIdentityUpdate: CartBuyerIdentityUpdate? { __data["cartBuyerIdentityUpdate"] }

      /// CartBuyerIdentityUpdate
      ///
      /// Parent Type: `CartBuyerIdentityUpdatePayload`
      public struct CartBuyerIdentityUpdate: ShopifyAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CartBuyerIdentityUpdatePayload }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("cart", Cart?.self),
          .field("userErrors", [UserError].self),
        ] }

        /// The updated cart.
        public var cart: Cart? { __data["cart"] }
        /// The list of errors that occurred from executing the mutation.
        public var userErrors: [UserError] { __data["userErrors"] }

        /// CartBuyerIdentityUpdate.Cart
        ///
        /// Parent Type: `Cart`
        public struct Cart: ShopifyAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Cart }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(CartFragment.self),
          ] }

          /// A globally-unique ID.
          public var id: ShopifyAPI.ID { __data["id"] }
          /// The URL of the checkout for the cart.
          public var checkoutUrl: ShopifyAPI.URL { __data["checkoutUrl"] }
          /// The total number of items in the cart.
          public var totalQuantity: Int { __data["totalQuantity"] }
          /// A note that's associated with the cart. For example, the note can be a personalized message to the buyer.
          public var note: String? { __data["note"] }
          /// A list of lines containing information about the items the customer intends to purchase.
          public var lines: Lines { __data["lines"] }
          /// The estimated costs that the buyer will pay at checkout. The costs are subject to change and changes will be reflected at checkout. The `cost` field uses the `buyerIdentity` field to determine [international pricing](https://shopify.dev/custom-storefronts/internationalization/international-pricing).
          public var cost: Cost { __data["cost"] }
          /// The case-insensitive discount codes that the customer added at checkout.
          public var discountCodes: [DiscountCode] { __data["discountCodes"] }
          /// Information about the buyer that's interacting with the cart.
          public var buyerIdentity: BuyerIdentity { __data["buyerIdentity"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var cartFragment: CartFragment { _toFragment() }
          }

          public typealias Lines = CartFragment.Lines

          public typealias Cost = CartFragment.Cost

          public typealias DiscountCode = CartFragment.DiscountCode

          public typealias BuyerIdentity = CartFragment.BuyerIdentity
        }

        /// CartBuyerIdentityUpdate.UserError
        ///
        /// Parent Type: `CartUserError`
        public struct UserError: ShopifyAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CartUserError }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("field", [String]?.self),
            .field("message", String.self),
            .field("code", GraphQLEnum<ShopifyAPI.CartErrorCode>?.self),
          ] }

          /// The path to the input field that caused the error.
          public var field: [String]? { __data["field"] }
          /// The error message.
          public var message: String { __data["message"] }
          /// The error code.
          public var code: GraphQLEnum<ShopifyAPI.CartErrorCode>? { __data["code"] }
        }
      }
    }
  }

}