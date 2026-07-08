// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension ShopifyAPI {
  class SearchProductsQuery: GraphQLQuery {
    public static let operationName: String = "SearchProducts"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query SearchProducts($query: String!, $first: Int!, $after: String) { search(query: $query, first: $first, after: $after, types: [PRODUCT]) { __typename totalCount edges { __typename cursor node { __typename ... on Product { id title vendor availableForSale priceRange { __typename minVariantPrice { __typename amount currencyCode } } images(first: 1) { __typename edges { __typename node { __typename url altText } } } variants(first: 5) { __typename edges { __typename node { __typename id title availableForSale quantityAvailable price { __typename amount currencyCode } } } } } } } pageInfo { __typename hasNextPage endCursor } } }"#
      ))

    public var query: String
    public var first: Int
    public var after: GraphQLNullable<String>

    public init(
      query: String,
      first: Int,
      after: GraphQLNullable<String>
    ) {
      self.query = query
      self.first = first
      self.after = after
    }

    public var __variables: Variables? { [
      "query": query,
      "first": first,
      "after": after
    ] }

    public struct Data: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.QueryRoot }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("search", Search.self, arguments: [
          "query": .variable("query"),
          "first": .variable("first"),
          "after": .variable("after"),
          "types": ["PRODUCT"]
        ]),
      ] }

      /// Returns paginated search results for [`Product`](https://shopify.dev/docs/api/storefront/current/objects/Product), [`Page`](https://shopify.dev/docs/api/storefront/current/objects/Page), and [`Article`](https://shopify.dev/docs/api/storefront/current/objects/Article) resources based on a query string. Results are sorted by relevance by default.
      ///
      /// The response includes the total result count and available product filters for building [faceted search interfaces](https://shopify.dev/docs/storefronts/headless/building-with-the-storefront-api/products-collections/filter-products). Use the [`prefix`](https://shopify.dev/docs/api/storefront/current/enums/SearchPrefixQueryType) argument to enable partial word matching on the last search term, allowing queries like "winter snow" to match "snowboard" or "snowshoe".
      ///
      public var search: Search { __data["search"] }

      /// Search
      ///
      /// Parent Type: `SearchResultItemConnection`
      public struct Search: ShopifyAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.SearchResultItemConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("totalCount", Int.self),
          .field("edges", [Edge].self),
          .field("pageInfo", PageInfo.self),
        ] }

        /// The total number of results.
        public var totalCount: Int { __data["totalCount"] }
        /// A list of edges.
        public var edges: [Edge] { __data["edges"] }
        /// Information to aid in pagination.
        public var pageInfo: PageInfo { __data["pageInfo"] }

        /// Search.Edge
        ///
        /// Parent Type: `SearchResultItemEdge`
        public struct Edge: ShopifyAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.SearchResultItemEdge }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("cursor", String.self),
            .field("node", Node.self),
          ] }

          /// A cursor for use in pagination.
          public var cursor: String { __data["cursor"] }
          /// The item at the end of SearchResultItemEdge.
          public var node: Node { __data["node"] }

          /// Search.Edge.Node
          ///
          /// Parent Type: `SearchResultItem`
          public struct Node: ShopifyAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Unions.SearchResultItem }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .inlineFragment(AsProduct.self),
            ] }

            public var asProduct: AsProduct? { _asInlineFragment() }

            /// Search.Edge.Node.AsProduct
            ///
            /// Parent Type: `Product`
            public struct AsProduct: ShopifyAPI.InlineFragment {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public typealias RootEntityType = SearchProductsQuery.Data.Search.Edge.Node
              public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Product }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("id", ShopifyAPI.ID.self),
                .field("title", String.self),
                .field("vendor", String.self),
                .field("availableForSale", Bool.self),
                .field("priceRange", PriceRange.self),
                .field("images", Images.self, arguments: ["first": 1]),
                .field("variants", Variants.self, arguments: ["first": 5]),
              ] }

              /// A globally-unique ID.
              public var id: ShopifyAPI.ID { __data["id"] }
              /// The name for the product that displays to customers. The title is used to construct the product's handle.
              /// For example, if a product is titled "Black Sunglasses", then the handle is `black-sunglasses`.
              ///
              public var title: String { __data["title"] }
              /// The name of the product's vendor.
              public var vendor: String { __data["vendor"] }
              /// Indicates if at least one product variant is available for sale.
              public var availableForSale: Bool { __data["availableForSale"] }
              /// The minimum and maximum prices of a product, expressed in decimal numbers.
              /// For example, if the product is priced between $10.00 and $50.00,
              /// then the price range is $10.00 - $50.00.
              ///
              public var priceRange: PriceRange { __data["priceRange"] }
              /// List of images associated with the product.
              public var images: Images { __data["images"] }
              /// A list of [variants](/docs/api/storefront/latest/objects/ProductVariant) that are associated with the product.
              public var variants: Variants { __data["variants"] }

              /// Search.Edge.Node.AsProduct.PriceRange
              ///
              /// Parent Type: `ProductPriceRange`
              public struct PriceRange: ShopifyAPI.SelectionSet {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.ProductPriceRange }
                public static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("minVariantPrice", MinVariantPrice.self),
                ] }

                /// The lowest variant's price.
                public var minVariantPrice: MinVariantPrice { __data["minVariantPrice"] }

                /// Search.Edge.Node.AsProduct.PriceRange.MinVariantPrice
                ///
                /// Parent Type: `MoneyV2`
                public struct MinVariantPrice: ShopifyAPI.SelectionSet {
                  public let __data: DataDict
                  public init(_dataDict: DataDict) { __data = _dataDict }

                  public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MoneyV2 }
                  public static var __selections: [ApolloAPI.Selection] { [
                    .field("__typename", String.self),
                    .field("amount", ShopifyAPI.Decimal.self),
                    .field("currencyCode", GraphQLEnum<ShopifyAPI.CurrencyCode>.self),
                  ] }

                  /// Decimal money amount.
                  public var amount: ShopifyAPI.Decimal { __data["amount"] }
                  /// Currency of the money.
                  public var currencyCode: GraphQLEnum<ShopifyAPI.CurrencyCode> { __data["currencyCode"] }
                }
              }

              /// Search.Edge.Node.AsProduct.Images
              ///
              /// Parent Type: `ImageConnection`
              public struct Images: ShopifyAPI.SelectionSet {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.ImageConnection }
                public static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("edges", [Edge].self),
                ] }

                /// A list of edges.
                public var edges: [Edge] { __data["edges"] }

                /// Search.Edge.Node.AsProduct.Images.Edge
                ///
                /// Parent Type: `ImageEdge`
                public struct Edge: ShopifyAPI.SelectionSet {
                  public let __data: DataDict
                  public init(_dataDict: DataDict) { __data = _dataDict }

                  public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.ImageEdge }
                  public static var __selections: [ApolloAPI.Selection] { [
                    .field("__typename", String.self),
                    .field("node", Node.self),
                  ] }

                  /// The item at the end of ImageEdge.
                  public var node: Node { __data["node"] }

                  /// Search.Edge.Node.AsProduct.Images.Edge.Node
                  ///
                  /// Parent Type: `Image`
                  public struct Node: ShopifyAPI.SelectionSet {
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

              /// Search.Edge.Node.AsProduct.Variants
              ///
              /// Parent Type: `ProductVariantConnection`
              public struct Variants: ShopifyAPI.SelectionSet {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.ProductVariantConnection }
                public static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("edges", [Edge].self),
                ] }

                /// A list of edges.
                public var edges: [Edge] { __data["edges"] }

                /// Search.Edge.Node.AsProduct.Variants.Edge
                ///
                /// Parent Type: `ProductVariantEdge`
                public struct Edge: ShopifyAPI.SelectionSet {
                  public let __data: DataDict
                  public init(_dataDict: DataDict) { __data = _dataDict }

                  public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.ProductVariantEdge }
                  public static var __selections: [ApolloAPI.Selection] { [
                    .field("__typename", String.self),
                    .field("node", Node.self),
                  ] }

                  /// The item at the end of ProductVariantEdge.
                  public var node: Node { __data["node"] }

                  /// Search.Edge.Node.AsProduct.Variants.Edge.Node
                  ///
                  /// Parent Type: `ProductVariant`
                  public struct Node: ShopifyAPI.SelectionSet {
                    public let __data: DataDict
                    public init(_dataDict: DataDict) { __data = _dataDict }

                    public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.ProductVariant }
                    public static var __selections: [ApolloAPI.Selection] { [
                      .field("__typename", String.self),
                      .field("id", ShopifyAPI.ID.self),
                      .field("title", String.self),
                      .field("availableForSale", Bool.self),
                      .field("quantityAvailable", Int?.self),
                      .field("price", Price.self),
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

                    /// Search.Edge.Node.AsProduct.Variants.Edge.Node.Price
                    ///
                    /// Parent Type: `MoneyV2`
                    public struct Price: ShopifyAPI.SelectionSet {
                      public let __data: DataDict
                      public init(_dataDict: DataDict) { __data = _dataDict }

                      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MoneyV2 }
                      public static var __selections: [ApolloAPI.Selection] { [
                        .field("__typename", String.self),
                        .field("amount", ShopifyAPI.Decimal.self),
                        .field("currencyCode", GraphQLEnum<ShopifyAPI.CurrencyCode>.self),
                      ] }

                      /// Decimal money amount.
                      public var amount: ShopifyAPI.Decimal { __data["amount"] }
                      /// Currency of the money.
                      public var currencyCode: GraphQLEnum<ShopifyAPI.CurrencyCode> { __data["currencyCode"] }
                    }
                  }
                }
              }
            }
          }
        }

        /// Search.PageInfo
        ///
        /// Parent Type: `PageInfo`
        public struct PageInfo: ShopifyAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.PageInfo }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("hasNextPage", Bool.self),
            .field("endCursor", String?.self),
          ] }

          /// Whether there are more pages to fetch following the current page.
          public var hasNextPage: Bool { __data["hasNextPage"] }
          /// The cursor corresponding to the last node in edges.
          public var endCursor: String? { __data["endCursor"] }
        }
      }
    }
  }

}