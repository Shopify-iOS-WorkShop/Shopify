// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension ShopifyAPI {
  class GetCartQuery: GraphQLQuery {
    public static let operationName: String = "GetCart"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetCart($cartId: ID!) { cart(id: $cartId) { __typename ...CartFragment } }"#,
        fragments: [CartFragment.self, CartLineFragment.self, MoneyFragment.self]
      ))

    public var cartId: ID

    public init(cartId: ID) {
      self.cartId = cartId
    }

    public var __variables: Variables? { ["cartId": cartId] }

    public struct Data: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.QueryRoot }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("cart", Cart?.self, arguments: ["id": .variable("cartId")]),
      ] }

      /// Returns a [`Cart`](https://shopify.dev/docs/api/storefront/current/objects/Cart) by its ID. The cart contains the merchandise lines a buyer intends to purchase, along with estimated costs, applied discounts, gift cards, and delivery options.
      ///
      /// Use the [`checkoutUrl`](https://shopify.dev/docs/api/storefront/latest/queries/cart#returns-Cart.fields.checkoutUrl) field to redirect buyers to Shopify's web checkout when they're ready to complete their purchase. For more information, refer to [Manage a cart with the Storefront API](https://shopify.dev/docs/storefronts/headless/building-with-the-storefront-api/cart/manage).
      ///
      public var cart: Cart? { __data["cart"] }

      /// Cart
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
    }
  }

}