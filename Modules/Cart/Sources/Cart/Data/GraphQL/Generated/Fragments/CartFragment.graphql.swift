// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension CartAPI {
  struct CartFragment: CartAPI.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment CartFragment on Cart { __typename id checkoutUrl totalQuantity note lines(first: 250) { __typename nodes { __typename ...CartLineFragment } } cost { __typename subtotalAmount { __typename ...MoneyFragment } totalAmount { __typename ...MoneyFragment } checkoutChargeAmount { __typename ...MoneyFragment } } discountCodes { __typename code applicable } buyerIdentity { __typename email phone customer { __typename id } } }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: ApolloAPI.ParentType { CartAPI.Objects.Cart }
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
    struct Lines: CartAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { CartAPI.Objects.BaseCartLineConnection }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("nodes", [Node].self),
      ] }

      /// A list of the nodes contained in BaseCartLineEdge.
      var nodes: [Node] { __data["nodes"] }

      /// Lines.Node
      ///
      /// Parent Type: `BaseCartLine`
      struct Node: CartAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { CartAPI.Interfaces.BaseCartLine }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(CartLineFragment.self),
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

        /// Lines.Node.Merchandise
        ///
        /// Parent Type: `Merchandise`
        struct Merchandise: CartAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { CartAPI.Unions.Merchandise }

          var asProductVariant: AsProductVariant? { _asInlineFragment() }

          /// Lines.Node.Merchandise.AsProductVariant
          ///
          /// Parent Type: `ProductVariant`
          struct AsProductVariant: CartAPI.InlineFragment, ApolloAPI.CompositeInlineFragment {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            typealias RootEntityType = CartFragment.Lines.Node.Merchandise
            static var __parentType: ApolloAPI.ParentType { CartAPI.Objects.ProductVariant }
            public static var __mergedSources: [any ApolloAPI.SelectionSet.Type] { [
              CartLineFragment.Merchandise.AsProductVariant.self
            ] }

            /// A globally-unique ID.
            var id: CartAPI.ID { __data["id"] }
            /// The product variant’s title.
            var title: String { __data["title"] }
            /// Indicates if the product variant is available for sale.
            var availableForSale: Bool { __data["availableForSale"] }
            /// The total sellable quantity of the variant for online sales channels.
            var quantityAvailable: Int? { __data["quantityAvailable"] }
            /// The product variant’s price.
            var price: Price { __data["price"] }
            /// The compare at price of the variant. This can be used to mark a variant as on sale, when `compareAtPrice` is higher than `price`.
            var compareAtPrice: CompareAtPrice? { __data["compareAtPrice"] }
            /// Image associated with the product variant. This field falls back to the product image if no image is available.
            var image: Image? { __data["image"] }
            /// List of product options applied to the variant.
            var selectedOptions: [SelectedOption] { __data["selectedOptions"] }
            /// The product object that the product variant belongs to.
            var product: Product { __data["product"] }

            /// Lines.Node.Merchandise.AsProductVariant.Price
            ///
            /// Parent Type: `MoneyV2`
            struct Price: CartAPI.SelectionSet {
              let __data: DataDict
              init(_dataDict: DataDict) { __data = _dataDict }

              static var __parentType: ApolloAPI.ParentType { CartAPI.Objects.MoneyV2 }

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

            /// Lines.Node.Merchandise.AsProductVariant.CompareAtPrice
            ///
            /// Parent Type: `MoneyV2`
            struct CompareAtPrice: CartAPI.SelectionSet {
              let __data: DataDict
              init(_dataDict: DataDict) { __data = _dataDict }

              static var __parentType: ApolloAPI.ParentType { CartAPI.Objects.MoneyV2 }

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

            typealias Image = CartLineFragment.Merchandise.AsProductVariant.Image

            typealias SelectedOption = CartLineFragment.Merchandise.AsProductVariant.SelectedOption

            typealias Product = CartLineFragment.Merchandise.AsProductVariant.Product
          }
        }

        typealias Cost = CartLineFragment.Cost

        typealias DiscountAllocation = CartLineFragment.DiscountAllocation
      }
    }

    /// Cost
    ///
    /// Parent Type: `CartCost`
    struct Cost: CartAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { CartAPI.Objects.CartCost }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("subtotalAmount", SubtotalAmount.self),
        .field("totalAmount", TotalAmount.self),
        .field("checkoutChargeAmount", CheckoutChargeAmount.self),
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
      struct SubtotalAmount: CartAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { CartAPI.Objects.MoneyV2 }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(MoneyFragment.self),
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
      struct TotalAmount: CartAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { CartAPI.Objects.MoneyV2 }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(MoneyFragment.self),
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
      struct CheckoutChargeAmount: CartAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { CartAPI.Objects.MoneyV2 }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(MoneyFragment.self),
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
    struct DiscountCode: CartAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { CartAPI.Objects.CartDiscountCode }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("code", String.self),
        .field("applicable", Bool.self),
      ] }

      /// The code for the discount.
      var code: String { __data["code"] }
      /// Whether the discount code is applicable to the cart's current contents.
      var applicable: Bool { __data["applicable"] }
    }

    /// BuyerIdentity
    ///
    /// Parent Type: `CartBuyerIdentity`
    struct BuyerIdentity: CartAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { CartAPI.Objects.CartBuyerIdentity }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("email", String?.self),
        .field("phone", String?.self),
        .field("customer", Customer?.self),
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
      struct Customer: CartAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { CartAPI.Objects.Customer }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", CartAPI.ID.self),
        ] }

        /// A unique ID for the customer.
        var id: CartAPI.ID { __data["id"] }
      }
    }
  }

}