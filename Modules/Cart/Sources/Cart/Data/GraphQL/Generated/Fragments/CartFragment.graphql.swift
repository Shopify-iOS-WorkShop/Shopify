// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

extension CartAPI {
  nonisolated struct CartFragment: CartAPI.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment CartFragment on Cart { __typename id checkoutUrl totalQuantity note lines(first: 250) { __typename nodes { __typename ...CartLineFragment } } cost { __typename subtotalAmount { __typename ...MoneyFragment } totalAmount { __typename ...MoneyFragment } checkoutChargeAmount { __typename ...MoneyFragment } } discountCodes { __typename code applicable } buyerIdentity { __typename email phone customer { __typename id } } }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { CartAPI.Objects.Cart }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", CartAPI.ID.self),
      .field("checkoutUrl", CartAPI.URL.self),
      .field("totalQuantity", Int.self),
      .field("note", String?.self),
      .field("lines", Lines.self, arguments: ["first": 250]),
      .field("cost", Cost.self),
      .field("discountCodes", [DiscountCode].self),
      .field("buyerIdentity", BuyerIdentity.self),
    ] }
    static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
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

    /// Lines
    ///
    /// Parent Type: `BaseCartLineConnection`
    nonisolated struct Lines: CartAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { CartAPI.Objects.BaseCartLineConnection }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("nodes", [Node].self),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        CartFragment.Lines.self
      ] }

      /// A list of the nodes contained in BaseCartLineEdge.
      var nodes: [Node] { __data["nodes"] }

      /// Lines.Node
      ///
      /// Parent Type: `BaseCartLine`
      nonisolated struct Node: CartAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { CartAPI.Interfaces.BaseCartLine }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(CartLineFragment.self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          CartFragment.Lines.Node.self,
          CartLineFragment.self
        ] }

        /// A globally-unique ID.
        var id: CartAPI.ID { __data["id"] }
        /// The quantity of the merchandise that the customer intends to purchase.
        var quantity: Int { __data["quantity"] }
        /// The merchandise that the buyer intends to purchase.
        var merchandise: Merchandise { __data["merchandise"] }
        /// The cost of the merchandise that the buyer will pay for at checkout. The costs are subject to change and changes will be reflected at checkout.
        var cost: Cost { __data["cost"] }
        /// The discounts that have been applied to the cart line.
        var discountAllocations: [DiscountAllocation] { __data["discountAllocations"] }

        struct Fragments: FragmentContainer {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          var cartLineFragment: CartLineFragment { _toFragment() }
        }

        typealias Merchandise = CartLineFragment.Merchandise

        typealias Cost = CartLineFragment.Cost

        typealias DiscountAllocation = CartLineFragment.DiscountAllocation
      }
    }

    /// Cost
    ///
    /// Parent Type: `CartCost`
    nonisolated struct Cost: CartAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { CartAPI.Objects.CartCost }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("subtotalAmount", SubtotalAmount.self),
        .field("totalAmount", TotalAmount.self),
        .field("checkoutChargeAmount", CheckoutChargeAmount.self),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        CartFragment.Cost.self
      ] }

      /// The amount, before taxes and cart-level discounts, for the customer to pay.
      var subtotalAmount: SubtotalAmount { __data["subtotalAmount"] }
      /// The total amount for the customer to pay.
      var totalAmount: TotalAmount { __data["totalAmount"] }
      /// The estimated amount, before taxes and discounts, for the customer to pay at checkout. The checkout charge amount doesn't include any deferred payments that'll be paid at a later date. If the cart has no deferred payments, then the checkout charge amount is equivalent to `subtotalAmount`.
      var checkoutChargeAmount: CheckoutChargeAmount { __data["checkoutChargeAmount"] }

      /// Cost.SubtotalAmount
      ///
      /// Parent Type: `MoneyV2`
      nonisolated struct SubtotalAmount: CartAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { CartAPI.Objects.MoneyV2 }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(MoneyFragment.self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          CartFragment.Cost.SubtotalAmount.self,
          MoneyFragment.self
        ] }

        /// Decimal money amount.
        var amount: CartAPI.Decimal { __data["amount"] }
        /// Currency of the money.
        var currencyCode: GraphQLEnum<CartAPI.CurrencyCode> { __data["currencyCode"] }

        struct Fragments: FragmentContainer {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          var moneyFragment: MoneyFragment { _toFragment() }
        }
      }

      /// Cost.TotalAmount
      ///
      /// Parent Type: `MoneyV2`
      nonisolated struct TotalAmount: CartAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { CartAPI.Objects.MoneyV2 }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(MoneyFragment.self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          CartFragment.Cost.TotalAmount.self,
          MoneyFragment.self
        ] }

        /// Decimal money amount.
        var amount: CartAPI.Decimal { __data["amount"] }
        /// Currency of the money.
        var currencyCode: GraphQLEnum<CartAPI.CurrencyCode> { __data["currencyCode"] }

        struct Fragments: FragmentContainer {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          var moneyFragment: MoneyFragment { _toFragment() }
        }
      }

      /// Cost.CheckoutChargeAmount
      ///
      /// Parent Type: `MoneyV2`
      nonisolated struct CheckoutChargeAmount: CartAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { CartAPI.Objects.MoneyV2 }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(MoneyFragment.self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          CartFragment.Cost.CheckoutChargeAmount.self,
          MoneyFragment.self
        ] }

        /// Decimal money amount.
        var amount: CartAPI.Decimal { __data["amount"] }
        /// Currency of the money.
        var currencyCode: GraphQLEnum<CartAPI.CurrencyCode> { __data["currencyCode"] }

        struct Fragments: FragmentContainer {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          var moneyFragment: MoneyFragment { _toFragment() }
        }
      }
    }

    /// DiscountCode
    ///
    /// Parent Type: `CartDiscountCode`
    nonisolated struct DiscountCode: CartAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { CartAPI.Objects.CartDiscountCode }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("code", String.self),
        .field("applicable", Bool.self),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        CartFragment.DiscountCode.self
      ] }

      /// The code for the discount.
      var code: String { __data["code"] }
      /// Whether the discount code is applicable to the cart's current contents.
      var applicable: Bool { __data["applicable"] }
    }

    /// BuyerIdentity
    ///
    /// Parent Type: `CartBuyerIdentity`
    nonisolated struct BuyerIdentity: CartAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { CartAPI.Objects.CartBuyerIdentity }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("email", String?.self),
        .field("phone", String?.self),
        .field("customer", Customer?.self),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        CartFragment.BuyerIdentity.self
      ] }

      /// The email address of the buyer that's interacting with the cart.
      var email: String? { __data["email"] }
      /// The phone number of the buyer that's interacting with the cart.
      var phone: String? { __data["phone"] }
      /// The customer account associated with the cart.
      var customer: Customer? { __data["customer"] }

      /// BuyerIdentity.Customer
      ///
      /// Parent Type: `Customer`
      nonisolated struct Customer: CartAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { CartAPI.Objects.Customer }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", CartAPI.ID.self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          CartFragment.BuyerIdentity.Customer.self
        ] }

        /// A unique ID for the customer.
        var id: CartAPI.ID { __data["id"] }
      }
    }
  }

}