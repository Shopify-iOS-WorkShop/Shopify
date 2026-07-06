// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension ShopifyAPI {
  class CustomerAddressUpdateMutation: GraphQLMutation {
    public static let operationName: String = "CustomerAddressUpdate"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation CustomerAddressUpdate($customerAccessToken: String!, $id: ID!, $address: MailingAddressInput!) { customerAddressUpdate( customerAccessToken: $customerAccessToken id: $id address: $address ) { __typename customerUserErrors { __typename message } } }"#
      ))

    public var customerAccessToken: String
    public var id: ID
    public var address: MailingAddressInput

    public init(
      customerAccessToken: String,
      id: ID,
      address: MailingAddressInput
    ) {
      self.customerAccessToken = customerAccessToken
      self.id = id
      self.address = address
    }

    public var __variables: Variables? { [
      "customerAccessToken": customerAccessToken,
      "id": id,
      "address": address
    ] }

    public struct Data: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("customerAddressUpdate", CustomerAddressUpdate?.self, arguments: [
          "customerAccessToken": .variable("customerAccessToken"),
          "id": .variable("id"),
          "address": .variable("address")
        ]),
      ] }

      /// Updates an existing [`MailingAddress`](https://shopify.dev/docs/api/storefront/current/objects/MailingAddress) for a [`Customer`](https://shopify.dev/docs/api/storefront/current/objects/Customer). Requires a [customer access token](https://shopify.dev/docs/api/storefront/current/mutations/customerAddressUpdate#arguments-customerAccessToken) to identify the customer, an ID to specify which address to modify, and an [`address`](https://shopify.dev/docs/api/storefront/current/input-objects/MailingAddressInput) with the updated fields.
      ///
      /// Successful update returns the updated [`MailingAddress`](https://shopify.dev/docs/api/storefront/current/objects/MailingAddress).
      ///
      public var customerAddressUpdate: CustomerAddressUpdate? { __data["customerAddressUpdate"] }

      /// CustomerAddressUpdate
      ///
      /// Parent Type: `CustomerAddressUpdatePayload`
      public struct CustomerAddressUpdate: ShopifyAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CustomerAddressUpdatePayload }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("customerUserErrors", [CustomerUserError].self),
        ] }

        /// The list of errors that occurred from executing the mutation.
        public var customerUserErrors: [CustomerUserError] { __data["customerUserErrors"] }

        /// CustomerAddressUpdate.CustomerUserError
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