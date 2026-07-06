// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension ShopifyAPI {
  struct CartFragment: ShopifyAPI.SelectionSet, Fragment {
    public static var fragmentDefinition: StaticString {
      #"fragment CartFragment on Cart { __typename id checkoutUrl totalQuantity note lines(first: 250) { __typename nodes { __typename ...CartLineFragment } } cost { __typename subtotalAmount { __typename ...MoneyFragment } totalAmount { __typename ...MoneyFragment } checkoutChargeAmount { __typename ...MoneyFragment } } discountCodes { __typename code applicable } buyerIdentity { __typename email phone customer { __typename id } } }"#
    }

    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Cart }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", ShopifyAPI.ID.self),
      .field("checkoutUrl", ShopifyAPI.URL.self),
      .field("totalQuantity", Int.self),
      .field("note", String?.self),
      .field("lines", Lines.self, arguments: ["first": 250]),
      .field("cost", Cost.self),
      .field("discountCodes", [DiscountCode].self),
      .field("buyerIdentity", BuyerIdentity.self),
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

    /// Lines
    ///
    /// Parent Type: `BaseCartLineConnection`
    public struct Lines: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.BaseCartLineConnection }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("nodes", [Node].self),
      ] }

      /// A list of the nodes contained in BaseCartLineEdge.
      public var nodes: [Node] { __data["nodes"] }

      /// Lines.Node
      ///
      /// Parent Type: `BaseCartLine`
      public struct Node: ShopifyAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Interfaces.BaseCartLine }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(CartLineFragment.self),
        ] }

        /// A globally-unique ID.
        public var id: ShopifyAPI.ID { __data["id"] }
        /// The quantity of the merchandise that the customer intends to purchase.
        public var quantity: Int { __data["quantity"] }
        /// The merchandise that the buyer intends to purchase.
        public var merchandise: Merchandise { __data["merchandise"] }
        /// The cost of the merchandise that the buyer will pay for at checkout. The costs are subject to change and changes will be reflected at checkout.
        public var cost: Cost { __data["cost"] }
        /// The discounts that have been applied to the cart line.
        public var discountAllocations: [DiscountAllocation] { __data["discountAllocations"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var cartLineFragment: CartLineFragment { _toFragment() }
        }

        /// Lines.Node.Merchandise
        ///
        /// Parent Type: `Merchandise`
        public struct Merchandise: ShopifyAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Unions.Merchandise }

          public var asProductVariant: AsProductVariant? { _asInlineFragment() }

          /// Lines.Node.Merchandise.AsProductVariant
          ///
          /// Parent Type: `ProductVariant`
          public struct AsProductVariant: ShopifyAPI.InlineFragment, ApolloAPI.CompositeInlineFragment {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public typealias RootEntityType = CartFragment.Lines.Node.Merchandise
            public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.ProductVariant }
            public static var __mergedSources: [any ApolloAPI.SelectionSet.Type] { [
              CartLineFragment.Merchandise.AsProductVariant.self
            ] }

            /// A globally-unique ID.
            public var id: ShopifyAPI.ID { __data["id"] }
            /// The product variant’s title.
            public var title: String { __data["title"] }
            /// Indicates if the product variant is available for sale.
            public var availableForSale: Bool { __data["availableForSale"] }
            /// The total sellable quantity of the variant for online sales channels.
            public var quantityAvailable: Int? { __data["quantityAvailable"] }
            /// The product variant’s price.
            public var price: Price { __data["price"] }
            /// The compare at price of the variant. This can be used to mark a variant as on sale, when `compareAtPrice` is higher than `price`.
            public var compareAtPrice: CompareAtPrice? { __data["compareAtPrice"] }
            /// Image associated with the product variant. This field falls back to the product image if no image is available.
            public var image: Image? { __data["image"] }
            /// List of product options applied to the variant.
            public var selectedOptions: [SelectedOption] { __data["selectedOptions"] }
            /// The product object that the product variant belongs to.
            public var product: Product { __data["product"] }

            /// Lines.Node.Merchandise.AsProductVariant.Price
            ///
            /// Parent Type: `MoneyV2`
            public struct Price: ShopifyAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MoneyV2 }

              /// Decimal money amount.
              public var amount: ShopifyAPI.Decimal { __data["amount"] }
              /// Currency of the money.
              public var currencyCode: GraphQLEnum<ShopifyAPI.CurrencyCode> { __data["currencyCode"] }

              public struct Fragments: FragmentContainer {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public var moneyFragment: MoneyFragment { _toFragment() }
              }
            }

            /// Lines.Node.Merchandise.AsProductVariant.CompareAtPrice
            ///
            /// Parent Type: `MoneyV2`
            public struct CompareAtPrice: ShopifyAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MoneyV2 }

              /// Decimal money amount.
              public var amount: ShopifyAPI.Decimal { __data["amount"] }
              /// Currency of the money.
              public var currencyCode: GraphQLEnum<ShopifyAPI.CurrencyCode> { __data["currencyCode"] }

              public struct Fragments: FragmentContainer {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public var moneyFragment: MoneyFragment { _toFragment() }
              }
            }

            public typealias Image = CartLineFragment.Merchandise.AsProductVariant.Image

            public typealias SelectedOption = CartLineFragment.Merchandise.AsProductVariant.SelectedOption

            public typealias Product = CartLineFragment.Merchandise.AsProductVariant.Product
          }
        }

        public typealias Cost = CartLineFragment.Cost

        public typealias DiscountAllocation = CartLineFragment.DiscountAllocation
      }
    }

    /// Cost
    ///
    /// Parent Type: `CartCost`
    public struct Cost: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CartCost }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("subtotalAmount", SubtotalAmount.self),
        .field("totalAmount", TotalAmount.self),
        .field("checkoutChargeAmount", CheckoutChargeAmount.self),
      ] }

      /// The amount, before taxes and cart-level discounts, for the customer to pay.
      public var subtotalAmount: SubtotalAmount { __data["subtotalAmount"] }
      /// The total amount for the customer to pay.
      public var totalAmount: TotalAmount { __data["totalAmount"] }
      /// The estimated amount, before taxes and discounts, for the customer to pay at checkout. The checkout charge amount doesn't include any deferred payments that'll be paid at a later date. If the cart has no deferred payments, then the checkout charge amount is equivalent to `subtotalAmount`.
      public var checkoutChargeAmount: CheckoutChargeAmount { __data["checkoutChargeAmount"] }

      /// Cost.SubtotalAmount
      ///
      /// Parent Type: `MoneyV2`
      public struct SubtotalAmount: ShopifyAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MoneyV2 }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(MoneyFragment.self),
        ] }

        /// Decimal money amount.
        public var amount: ShopifyAPI.Decimal { __data["amount"] }
        /// Currency of the money.
        public var currencyCode: GraphQLEnum<ShopifyAPI.CurrencyCode> { __data["currencyCode"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var moneyFragment: MoneyFragment { _toFragment() }
        }
      }

      /// Cost.TotalAmount
      ///
      /// Parent Type: `MoneyV2`
      public struct TotalAmount: ShopifyAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MoneyV2 }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(MoneyFragment.self),
        ] }

        /// Decimal money amount.
        public var amount: ShopifyAPI.Decimal { __data["amount"] }
        /// Currency of the money.
        public var currencyCode: GraphQLEnum<ShopifyAPI.CurrencyCode> { __data["currencyCode"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var moneyFragment: MoneyFragment { _toFragment() }
        }
      }

      /// Cost.CheckoutChargeAmount
      ///
      /// Parent Type: `MoneyV2`
      public struct CheckoutChargeAmount: ShopifyAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MoneyV2 }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(MoneyFragment.self),
        ] }

        /// Decimal money amount.
        public var amount: ShopifyAPI.Decimal { __data["amount"] }
        /// Currency of the money.
        public var currencyCode: GraphQLEnum<ShopifyAPI.CurrencyCode> { __data["currencyCode"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var moneyFragment: MoneyFragment { _toFragment() }
        }
      }
    }

    /// DiscountCode
    ///
    /// Parent Type: `CartDiscountCode`
    public struct DiscountCode: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CartDiscountCode }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("code", String.self),
        .field("applicable", Bool.self),
      ] }

      /// The code for the discount.
      public var code: String { __data["code"] }
      /// Whether the discount code is applicable to the cart's current contents.
      public var applicable: Bool { __data["applicable"] }
    }

    /// BuyerIdentity
    ///
    /// Parent Type: `CartBuyerIdentity`
    public struct BuyerIdentity: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CartBuyerIdentity }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("email", String?.self),
        .field("phone", String?.self),
        .field("customer", Customer?.self),
      ] }

      /// The email address of the buyer that's interacting with the cart.
      public var email: String? { __data["email"] }
      /// The phone number of the buyer that's interacting with the cart.
      public var phone: String? { __data["phone"] }
      /// The customer account associated with the cart.
      public var customer: Customer? { __data["customer"] }

      /// BuyerIdentity.Customer
      ///
      /// Parent Type: `Customer`
      public struct Customer: ShopifyAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Customer }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", ShopifyAPI.ID.self),
        ] }

        /// A unique ID for the customer.
        public var id: ShopifyAPI.ID { __data["id"] }
      }
    }
  }

}