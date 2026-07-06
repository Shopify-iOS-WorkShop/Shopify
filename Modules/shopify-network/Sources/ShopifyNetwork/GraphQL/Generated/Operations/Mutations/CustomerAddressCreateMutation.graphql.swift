// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension ShopifyAPI {
  class CustomerAddressCreateMutation: GraphQLMutation {
    public static let operationName: String = "CustomerAddressCreate"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation CustomerAddressCreate($customerAccessToken: String!, $address: MailingAddressInput!) { customerAddressCreate( customerAccessToken: $customerAccessToken address: $address ) { __typename customerUserErrors { __typename message } } }"#
      ))

    public var customerAccessToken: String
    public var address: MailingAddressInput

    public init(
      customerAccessToken: String,
      address: MailingAddressInput
    ) {
      self.customerAccessToken = customerAccessToken
      self.address = address
    }

    public var __variables: Variables? { [
      "customerAccessToken": customerAccessToken,
      "address": address
    ] }

    public struct Data: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("customerAddressCreate", CustomerAddressCreate?.self, arguments: [
          "customerAccessToken": .variable("customerAccessToken"),
          "address": .variable("address")
        ]),
      ] }

      /// Creates a new [`MailingAddress`](https://shopify.dev/docs/api/storefront/current/objects/MailingAddress) for a [`Customer`](https://shopify.dev/docs/api/storefront/current/objects/Customer). Use the customer's [access token](https://shopify.dev/docs/api/storefront/current/mutations/customerAddressCreate#arguments-customerAccessToken) to identify them. Successful creation returns the new address. 
      ///
      /// Each customer can have multiple addresses.
      ///
      public var customerAddressCreate: CustomerAddressCreate? { __data["customerAddressCreate"] }

      /// CustomerAddressCreate
      ///
      /// Parent Type: `CustomerAddressCreatePayload`
      public struct CustomerAddressCreate: ShopifyAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CustomerAddressCreatePayload }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("customerUserErrors", [CustomerUserError].self),
        ] }

        /// The list of errors that occurred from executing the mutation.
        public var customerUserErrors: [CustomerUserError] { __data["customerUserErrors"] }

        /// CustomerAddressCreate.CustomerUserError
        ///
        /// Parent Type: `CustomerUserError`
        public struct CustomerUserError: ShopifyAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CustomerUserError }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("message", String.self),
          ] }

          /// The error message.
          public var message: String { __data["message"] }
        }
      }
    }
  }

}