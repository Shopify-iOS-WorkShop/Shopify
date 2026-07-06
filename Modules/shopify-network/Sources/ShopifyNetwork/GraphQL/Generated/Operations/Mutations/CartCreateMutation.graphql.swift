// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension ShopifyAPI {
  class CartCreateMutation: GraphQLMutation {
    public static let operationName: String = "CartCreate"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation CartCreate($input: CartInput!) { cartCreate(input: $input) { __typename cart { __typename ...CartFragment } userErrors { __typename field message code } } }"#,
        fragments: [CartFragment.self, CartLineFragment.self, MoneyFragment.self]
      ))

    public var input: CartInput

    public init(input: CartInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("cartCreate", CartCreate?.self, arguments: ["input": .variable("input")]),
      ] }

      /// Creates a new [`Cart`](https://shopify.dev/docs/api/storefront/current/objects/Cart) for a buyer session. You can optionally initialize the cart with merchandise lines, discount codes, gift card codes, buyer identity for international pricing, and custom attributes.
      ///
      /// The returned cart includes a `checkoutUrl` that directs the buyer to complete their purchase.
      ///
      public var cartCreate: CartCreate? { __data["cartCreate"] }

      /// CartCreate
      ///
      /// Parent Type: `CartCreatePayload`
      public struct CartCreate: ShopifyAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CartCreatePayload }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("cart", Cart?.self),
          .field("userErrors", [UserError].self),
        ] }

        /// The new cart.
        public var cart: Cart? { __data["cart"] }
        /// The list of errors that occurred from executing the mutation.
        public var userErrors: [UserError] { __data["userErrors"] }

        /// CartCreate.Cart
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

        /// CartCreate.UserError
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