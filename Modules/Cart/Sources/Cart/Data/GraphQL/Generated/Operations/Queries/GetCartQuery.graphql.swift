// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

extension CartAPI {
  nonisolated struct GetCartQuery: GraphQLQuery {
    static let operationName: String = "GetCart"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetCart($cartId: ID!) { cart(id: $cartId) { __typename ...CartFragment } }"#,
        fragments: [CartFragment.self, CartLineFragment.self, MoneyFragment.self]
      ))

    public var cartId: ID

    public init(cartId: ID) {
      self.cartId = cartId
    }

    @_spi(Unsafe) public var __variables: Variables? { ["cartId": cartId] }

    nonisolated struct Data: CartAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { CartAPI.Objects.QueryRoot }
      static var __selections: [ApolloAPI.Selection] { [
        .field("cart", Cart?.self, arguments: ["id": .variable("cartId")]),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        GetCartQuery.Data.self
      ] }

      /// Returns a [`Cart`](https://shopify.dev/docs/api/storefront/current/objects/Cart) by its ID. The cart contains the merchandise lines a buyer intends to purchase, along with estimated costs, applied discounts, gift cards, and delivery options.
      ///
      /// Use the [`checkoutUrl`](https://shopify.dev/docs/api/storefront/latest/queries/cart#returns-Cart.fields.checkoutUrl) field to redirect buyers to Shopify's web checkout when they're ready to complete their purchase. For more information, refer to [Manage a cart with the Storefront API](https://shopify.dev/docs/storefronts/headless/building-with-the-storefront-api/cart/manage).
      ///
      var cart: Cart? { __data["cart"] }

      /// Cart
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
          GetCartQuery.Data.Cart.self,
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
    }
  }

}