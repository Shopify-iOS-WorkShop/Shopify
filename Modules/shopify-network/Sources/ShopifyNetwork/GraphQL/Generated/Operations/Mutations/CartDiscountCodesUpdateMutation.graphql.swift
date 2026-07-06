// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension ShopifyAPI {
  class CartDiscountCodesUpdateMutation: GraphQLMutation {
    public static let operationName: String = "CartDiscountCodesUpdate"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
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

    public var __variables: Variables? { [
      "cartId": cartId,
      "discountCodes": discountCodes
    ] }

    public struct Data: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("cartDiscountCodesUpdate", CartDiscountCodesUpdate?.self, arguments: [
          "cartId": .variable("cartId"),
          "discountCodes": .variable("discountCodes")
        ]),
      ] }

      /// Updates the discount codes applied to a [`Cart`](https://shopify.dev/docs/api/storefront/current/objects/Cart). This mutation replaces all existing discount codes with the provided list, so pass an empty array to remove all codes. Discount codes are case-insensitive.
      ///
      /// After updating, check each [`CartDiscountCode`](https://shopify.dev/docs/api/storefront/current/objects/CartDiscountCode) in the cart's [`discountCodes`](https://shopify.dev/docs/api/storefront/current/objects/Cart#field-Cart.fields.discountCodes) field to see whether the code is applicable to the cart's current contents.
      ///
      public var cartDiscountCodesUpdate: CartDiscountCodesUpdate? { __data["cartDiscountCodesUpdate"] }

      /// CartDiscountCodesUpdate
      ///
      /// Parent Type: `CartDiscountCodesUpdatePayload`
      public struct CartDiscountCodesUpdate: ShopifyAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CartDiscountCodesUpdatePayload }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("cart", Cart?.self),
          .field("userErrors", [UserError].self),
        ] }

        /// The updated cart.
        public var cart: Cart? { __data["cart"] }
        /// The list of errors that occurred from executing the mutation.
        public var userErrors: [UserError] { __data["userErrors"] }

        /// CartDiscountCodesUpdate.Cart
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

        /// CartDiscountCodesUpdate.UserError
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