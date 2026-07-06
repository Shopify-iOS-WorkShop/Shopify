// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension ShopifyAPI {
  struct CartLineFragment: ShopifyAPI.SelectionSet, Fragment {
    public static var fragmentDefinition: StaticString {
      #"fragment CartLineFragment on BaseCartLine { __typename id quantity merchandise { __typename ... on ProductVariant { id title availableForSale quantityAvailable price { __typename ...MoneyFragment } compareAtPrice { __typename ...MoneyFragment } image { __typename url altText width height } selectedOptions { __typename name value } product { __typename id title handle vendor featuredImage { __typename url altText } } } } cost { __typename amountPerQuantity { __typename ...MoneyFragment } compareAtAmountPerQuantity { __typename ...MoneyFragment } subtotalAmount { __typename ...MoneyFragment } totalAmount { __typename ...MoneyFragment } } discountAllocations { __typename discountedAmount { __typename ...MoneyFragment } } }"#
    }

    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Interfaces.BaseCartLine }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", ShopifyAPI.ID.self),
      .field("quantity", Int.self),
      .field("merchandise", Merchandise.self),
      .field("cost", Cost.self),
      .field("discountAllocations", [DiscountAllocation].self),
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

    /// Merchandise
    ///
    /// Parent Type: `Merchandise`
    public struct Merchandise: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Unions.Merchandise }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .inlineFragment(AsProductVariant.self),
      ] }

      public var asProductVariant: AsProductVariant? { _asInlineFragment() }

      /// Merchandise.AsProductVariant
      ///
      /// Parent Type: `ProductVariant`
      public struct AsProductVariant: ShopifyAPI.InlineFragment {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public typealias RootEntityType = CartLineFragment.Merchandise
        public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.ProductVariant }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("id", ShopifyAPI.ID.self),
          .field("title", String.self),
          .field("availableForSale", Bool.self),
          .field("quantityAvailable", Int?.self),
          .field("price", Price.self),
          .field("compareAtPrice", CompareAtPrice?.self),
          .field("image", Image?.self),
          .field("selectedOptions", [SelectedOption].self),
          .field("product", Product.self),
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

        /// Merchandise.AsProductVariant.Price
        ///
        /// Parent Type: `MoneyV2`
        public struct Price: ShopifyAPI.SelectionSet {
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

        /// Merchandise.AsProductVariant.CompareAtPrice
        ///
        /// Parent Type: `MoneyV2`
        public struct CompareAtPrice: ShopifyAPI.SelectionSet {
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

        /// Merchandise.AsProductVariant.Image
        ///
        /// Parent Type: `Image`
        public struct Image: ShopifyAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Image }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("url", ShopifyAPI.URL.self),
            .field("altText", String?.self),
            .field("width", Int?.self),
            .field("height", Int?.self),
          ] }

          /// The location of the image as a URL.
          ///
          /// If no transform options are specified, then the original image will be preserved including any pre-applied transforms.
          ///
          /// All transformation options are considered "best-effort". Any transformation that the original image type doesn't support will be ignored.
          ///
          /// If you need multiple variations of the same image, then you can use [GraphQL aliases](https://graphql.org/learn/queries/#aliases).
          ///
          public var url: ShopifyAPI.URL { __data["url"] }
          /// A word or phrase to share the nature or contents of an image.
          public var altText: String? { __data["altText"] }
          /// The original width of the image in pixels. Returns `null` if the image isn't hosted by Shopify.
          public var width: Int? { __data["width"] }
          /// The original height of the image in pixels. Returns `null` if the image isn't hosted by Shopify.
          public var height: Int? { __data["height"] }
        }

        /// Merchandise.AsProductVariant.SelectedOption
        ///
        /// Parent Type: `SelectedOption`
        public struct SelectedOption: ShopifyAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.SelectedOption }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("name", String.self),
            .field("value", String.self),
          ] }

          /// The product option’s name.
          public var name: String { __data["name"] }
          /// The product option’s value.
          public var value: String { __data["value"] }
        }

        /// Merchandise.AsProductVariant.Product
        ///
        /// Parent Type: `Product`
        public struct Product: ShopifyAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Product }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ShopifyAPI.ID.self),
            .field("title", String.self),
            .field("handle", String.self),
            .field("vendor", String.self),
            .field("featuredImage", FeaturedImage?.self),
          ] }

          /// A globally-unique ID.
          public var id: ShopifyAPI.ID { __data["id"] }
          /// The name for the product that displays to customers. The title is used to construct the product's handle.
          /// For example, if a product is titled "Black Sunglasses", then the handle is `black-sunglasses`.
          ///
          public var title: String { __data["title"] }
          /// A unique, human-readable string of the product's title.
          /// A handle can contain letters, hyphens (`-`), and numbers, but no spaces.
          /// The handle is used in the online store URL for the product.
          ///
          public var handle: String { __data["handle"] }
          /// The name of the product's vendor.
          public var vendor: String { __data["vendor"] }
          /// The featured image for the product.
          ///
          /// This field is functionally equivalent to `images(first: 1)`.
          ///
          public var featuredImage: FeaturedImage? { __data["featuredImage"] }

          /// Merchandise.AsProductVariant.Product.FeaturedImage
          ///
          /// Parent Type: `Image`
          public struct FeaturedImage: ShopifyAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Image }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("url", ShopifyAPI.URL.self),
              .field("altText", String?.self),
            ] }

            /// The location of the image as a URL.
            ///
            /// If no transform options are specified, then the original image will be preserved including any pre-applied transforms.
            ///
            /// All transformation options are considered "best-effort". Any transformation that the original image type doesn't support will be ignored.
            ///
            /// If you need multiple variations of the same image, then you can use [GraphQL aliases](https://graphql.org/learn/queries/#aliases).
            ///
            public var url: ShopifyAPI.URL { __data["url"] }
            /// A word or phrase to share the nature or contents of an image.
            public var altText: String? { __data["altText"] }
          }
        }
      }
    }

    /// Cost
    ///
    /// Parent Type: `CartLineCost`
    public struct Cost: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CartLineCost }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("amountPerQuantity", AmountPerQuantity.self),
        .field("compareAtAmountPerQuantity", CompareAtAmountPerQuantity?.self),
        .field("subtotalAmount", SubtotalAmount.self),
        .field("totalAmount", TotalAmount.self),
      ] }

      /// The amount of the merchandise line.
      public var amountPerQuantity: AmountPerQuantity { __data["amountPerQuantity"] }
      /// The compare at amount of the merchandise line.
      public var compareAtAmountPerQuantity: CompareAtAmountPerQuantity? { __data["compareAtAmountPerQuantity"] }
      /// The cost of the merchandise line before line-level discounts.
      public var subtotalAmount: SubtotalAmount { __data["subtotalAmount"] }
      /// The total cost of the merchandise line.
      public var totalAmount: TotalAmount { __data["totalAmount"] }

      /// Cost.AmountPerQuantity
      ///
      /// Parent Type: `MoneyV2`
      public struct AmountPerQuantity: ShopifyAPI.SelectionSet {
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

      /// Cost.CompareAtAmountPerQuantity
      ///
      /// Parent Type: `MoneyV2`
      public struct CompareAtAmountPerQuantity: ShopifyAPI.SelectionSet {
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
    }

    /// DiscountAllocation
    ///
    /// Parent Type: `CartDiscountAllocation`
    public struct DiscountAllocation: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Interfaces.CartDiscountAllocation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("discountedAmount", DiscountedAmount.self),
      ] }

      /// The discounted amount that has been applied to the cart line.
      public var discountedAmount: DiscountedAmount { __data["discountedAmount"] }

      /// DiscountAllocation.DiscountedAmount
      ///
      /// Parent Type: `MoneyV2`
      public struct DiscountedAmount: ShopifyAPI.SelectionSet {
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
  }

}