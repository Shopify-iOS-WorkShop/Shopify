// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension ShopifyAPI {
  class GetCustomerAddressesQuery: GraphQLQuery {
    public static let operationName: String = "GetCustomerAddresses"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetCustomerAddresses($customerAccessToken: String!) { customer(customerAccessToken: $customerAccessToken) { __typename defaultAddress { __typename id } addresses(first: 10) { __typename edges { __typename node { __typename id address1 city firstName lastName phone country } } } } }"#
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
          .field("defaultAddress", DefaultAddress?.self),
          .field("addresses", Addresses.self, arguments: ["first": 10]),
        ] }

        /// The customer’s default address.
        public var defaultAddress: DefaultAddress? { __data["defaultAddress"] }
        /// A list of addresses for the customer.
        public var addresses: Addresses { __data["addresses"] }

        /// Customer.DefaultAddress
        ///
        /// Parent Type: `MailingAddress`
        public struct DefaultAddress: ShopifyAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MailingAddress }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ShopifyAPI.ID.self),
          ] }

          /// A globally-unique ID.
          public var id: ShopifyAPI.ID { __data["id"] }
        }

        /// Customer.Addresses
        ///
        /// Parent Type: `MailingAddressConnection`
        public struct Addresses: ShopifyAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MailingAddressConnection }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("edges", [Edge].self),
          ] }

          /// A list of edges.
          public var edges: [Edge] { __data["edges"] }

          /// Customer.Addresses.Edge
          ///
          /// Parent Type: `MailingAddressEdge`
          public struct Edge: ShopifyAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MailingAddressEdge }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("node", Node.self),
            ] }

            /// The item at the end of MailingAddressEdge.
            public var node: Node { __data["node"] }

            /// Customer.Addresses.Edge.Node
            ///
            /// Parent Type: `MailingAddress`
            public struct Node: ShopifyAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MailingAddress }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("id", ShopifyAPI.ID.self),
                .field("address1", String?.self),
                .field("city", String?.self),
                .field("firstName", String?.self),
                .field("lastName", String?.self),
                .field("phone", String?.self),
                .field("country", String?.self),
              ] }

              /// A globally-unique ID.
              public var id: ShopifyAPI.ID { __data["id"] }
              /// The first line of the address. Typically the street address or PO Box number.
              public var address1: String? { __data["address1"] }
              /// The name of the city, district, village, or town.
              public var city: String? { __data["city"] }
              /// The first name of the customer.
              public var firstName: String? { __data["firstName"] }
              /// The last name of the customer.
              public var lastName: String? { __data["lastName"] }
              /// A unique phone number for the customer.
              ///
              /// Formatted using E.164 standard. For example, _+16135551111_.
              ///
              public var phone: String? { __data["phone"] }
              /// The name of the country.
              public var country: String? { __data["country"] }
            }
          }
        }
      }
    }
  }

}