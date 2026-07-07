// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension ShopifyAPI {
  class GetOrderDetailsQuery: GraphQLQuery {
    public static let operationName: String = "GetOrderDetails"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetOrderDetails($customerAccessToken: String!) { customer(customerAccessToken: $customerAccessToken) { __typename orders(first: 20, sortKey: PROCESSED_AT, reverse: true) { __typename edges { __typename node { __typename id orderNumber processedAt financialStatus totalPrice { __typename amount currencyCode } subtotalPrice { __typename amount currencyCode } shippingAddress { __typename firstName lastName address1 city country phone } lineItems(first: 20) { __typename edges { __typename node { __typename title quantity variant { __typename title price { __typename amount } image { __typename url } } } } } } } } } }"#
      ))

    public var customerAccessToken: String

    public init(customerAccessToken: String) {
      self.customerAccessToken = customerAccessToken
    }

    public var __variables: Variables? { ["customerAccessToken": customerAccessToken] }

    public struct Data: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.QueryRoot }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("customer", Customer?.self, arguments: ["customerAccessToken": .variable("customerAccessToken")]),
      ] }

      /// Retrieves the [`Customer`](https://shopify.dev/docs/api/storefront/current/objects/Customer) associated with the provided access token. Use the [`customerAccessTokenCreate`](https://shopify.dev/docs/api/storefront/current/mutations/customerAccessTokenCreate) mutation to obtain an access token using legacy customer account authentication (email and password).
      ///
      /// The returned customer includes data such as contact information, [addresses](https://shopify.dev/docs/api/storefront/current/objects/MailingAddress), [orders](https://shopify.dev/docs/api/storefront/current/objects/Order), and [custom data](https://shopify.dev/docs/apps/build/custom-data) associated with the customer.
      ///
      public var customer: Customer? { __data["customer"] }

      /// Customer
      ///
      /// Parent Type: `Customer`
      public struct Customer: ShopifyAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Customer }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("orders", Orders.self, arguments: [
            "first": 20,
            "sortKey": "PROCESSED_AT",
            "reverse": true
          ]),
        ] }

        /// The orders associated with the customer.
        public var orders: Orders { __data["orders"] }

        /// Customer.Orders
        ///
        /// Parent Type: `OrderConnection`
        public struct Orders: ShopifyAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.OrderConnection }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("edges", [Edge].self),
          ] }

          /// A list of edges.
          public var edges: [Edge] { __data["edges"] }

          /// Customer.Orders.Edge
          ///
          /// Parent Type: `OrderEdge`
          public struct Edge: ShopifyAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.OrderEdge }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("node", Node.self),
            ] }

            /// The item at the end of OrderEdge.
            public var node: Node { __data["node"] }

            /// Customer.Orders.Edge.Node
            ///
            /// Parent Type: `Order`
            public struct Node: ShopifyAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Order }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("id", ShopifyAPI.ID.self),
                .field("orderNumber", Int.self),
                .field("processedAt", ShopifyAPI.DateTime.self),
                .field("financialStatus", GraphQLEnum<ShopifyAPI.OrderFinancialStatus>?.self),
                .field("totalPrice", TotalPrice.self),
                .field("subtotalPrice", SubtotalPrice?.self),
                .field("shippingAddress", ShippingAddress?.self),
                .field("lineItems", LineItems.self, arguments: ["first": 20]),
              ] }

              /// A globally-unique ID.
              public var id: ShopifyAPI.ID { __data["id"] }
              /// A unique numeric identifier for the order for use by shop owner and customer.
              public var orderNumber: Int { __data["orderNumber"] }
              /// The date and time when the order was imported.
              /// This value can be set to dates in the past when importing from other systems.
              /// If no value is provided, it will be auto-generated based on current date and time.
              ///
              public var processedAt: ShopifyAPI.DateTime { __data["processedAt"] }
              /// The financial status of the order.
              public var financialStatus: GraphQLEnum<ShopifyAPI.OrderFinancialStatus>? { __data["financialStatus"] }
              /// The sum of all the prices of all the items in the order, duties, taxes and discounts included (must be positive).
              public var totalPrice: TotalPrice { __data["totalPrice"] }
              /// Price of the order before shipping and taxes.
              public var subtotalPrice: SubtotalPrice? { __data["subtotalPrice"] }
              /// The address to where the order will be shipped.
              public var shippingAddress: ShippingAddress? { __data["shippingAddress"] }
              /// List of the order’s line items.
              public var lineItems: LineItems { __data["lineItems"] }

              /// Customer.Orders.Edge.Node.TotalPrice
              ///
              /// Parent Type: `MoneyV2`
              public struct TotalPrice: ShopifyAPI.SelectionSet {
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

              /// Customer.Orders.Edge.Node.SubtotalPrice
              ///
              /// Parent Type: `MoneyV2`
              public struct SubtotalPrice: ShopifyAPI.SelectionSet {
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

              /// Customer.Orders.Edge.Node.ShippingAddress
              ///
              /// Parent Type: `MailingAddress`
              public struct ShippingAddress: ShopifyAPI.SelectionSet {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MailingAddress }
                public static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("firstName", String?.self),
                  .field("lastName", String?.self),
                  .field("address1", String?.self),
                  .field("city", String?.self),
                  .field("country", String?.self),
                  .field("phone", String?.self),
                ] }

                /// The first name of the customer.
                public var firstName: String? { __data["firstName"] }
                /// The last name of the customer.
                public var lastName: String? { __data["lastName"] }
                /// The first line of the address. Typically the street address or PO Box number.
                public var address1: String? { __data["address1"] }
                /// The name of the city, district, village, or town.
                public var city: String? { __data["city"] }
                /// The name of the country.
                public var country: String? { __data["country"] }
                /// A unique phone number for the customer.
                ///
                /// Formatted using E.164 standard. For example, _+16135551111_.
                ///
                public var phone: String? { __data["phone"] }
              }

              /// Customer.Orders.Edge.Node.LineItems
              ///
              /// Parent Type: `OrderLineItemConnection`
              public struct LineItems: ShopifyAPI.SelectionSet {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.OrderLineItemConnection }
                public static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("edges", [Edge].self),
                ] }

                /// A list of edges.
                public var edges: [Edge] { __data["edges"] }

                /// Customer.Orders.Edge.Node.LineItems.Edge
                ///
                /// Parent Type: `OrderLineItemEdge`
                public struct Edge: ShopifyAPI.SelectionSet {
                  public let __data: DataDict
                  public init(_dataDict: DataDict) { __data = _dataDict }

                  public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.OrderLineItemEdge }
                  public static var __selections: [ApolloAPI.Selection] { [
                    .field("__typename", String.self),
                    .field("node", Node.self),
                  ] }

                  /// The item at the end of OrderLineItemEdge.
                  public var node: Node { __data["node"] }

                  /// Customer.Orders.Edge.Node.LineItems.Edge.Node
                  ///
                  /// Parent Type: `OrderLineItem`
                  public struct Node: ShopifyAPI.SelectionSet {
                    public let __data: DataDict
                    public init(_dataDict: DataDict) { __data = _dataDict }

                    public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.OrderLineItem }
                    public static var __selections: [ApolloAPI.Selection] { [
                      .field("__typename", String.self),
                      .field("title", String.self),
                      .field("quantity", Int.self),
                      .field("variant", Variant?.self),
                    ] }

                    /// The title of the product combined with title of the variant.
                    public var title: String { __data["title"] }
                    /// The number of products variants associated to the line item.
                    public var quantity: Int { __data["quantity"] }
                    /// The product variant object associated to the line item.
                    public var variant: Variant? { __data["variant"] }

                    /// Customer.Orders.Edge.Node.LineItems.Edge.Node.Variant
                    ///
                    /// Parent Type: `ProductVariant`
                    public struct Variant: ShopifyAPI.SelectionSet {
                      public let __data: DataDict
                      public init(_dataDict: DataDict) { __data = _dataDict }

                      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.ProductVariant }
                      public static var __selections: [ApolloAPI.Selection] { [
                        .field("__typename", String.self),
                        .field("title", String.self),
                        .field("price", Price.self),
                        .field("image", Image?.self),
                      ] }

                      /// The product variant’s title.
                      public var title: String { __data["title"] }
                      /// The product variant’s price.
                      public var price: Price { __data["price"] }
                      /// Image associated with the product variant. This field falls back to the product image if no image is available.
                      public var image: Image? { __data["image"] }

                      /// Customer.Orders.Edge.Node.LineItems.Edge.Node.Variant.Price
                      ///
                      /// Parent Type: `MoneyV2`
                      public struct Price: ShopifyAPI.SelectionSet {
                        public let __data: DataDict
                        public init(_dataDict: DataDict) { __data = _dataDict }

                        public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MoneyV2 }
                        public static var __selections: [ApolloAPI.Selection] { [
                          .field("__typename", String.self),
                          .field("amount", ShopifyAPI.Decimal.self),
                        ] }

                        /// Decimal money amount.
                        public var amount: ShopifyAPI.Decimal { __data["amount"] }
                      }

                      /// Customer.Orders.Edge.Node.LineItems.Edge.Node.Variant.Image
                      ///
                      /// Parent Type: `Image`
                      public struct Image: ShopifyAPI.SelectionSet {
                        public let __data: DataDict
                        public init(_dataDict: DataDict) { __data = _dataDict }

                        public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Image }
                        public static var __selections: [ApolloAPI.Selection] { [
                          .field("__typename", String.self),
                          .field("url", ShopifyAPI.URL.self),
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
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

}