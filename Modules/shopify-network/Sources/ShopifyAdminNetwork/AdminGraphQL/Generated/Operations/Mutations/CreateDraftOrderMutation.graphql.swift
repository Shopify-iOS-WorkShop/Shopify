// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension ShopifyAdminAPI {
  class CreateDraftOrderMutation: GraphQLMutation {
    public static let operationName: String = "CreateDraftOrder"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation CreateDraftOrder($input: DraftOrderInput!) { draftOrderCreate(input: $input) { __typename draftOrder { __typename id } userErrors { __typename message } } }"#
      ))

    public var input: DraftOrderInput

    public init(input: DraftOrderInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: ShopifyAdminAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAdminAPI.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("draftOrderCreate", DraftOrderCreate?.self, arguments: ["input": .variable("input")]),
      ] }

      /// Creates a [draft order](https://shopify.dev/docs/api/admin-graphql/latest/objects/DraftOrder)
      /// with attributes such as customer information, line items, shipping and billing addresses, and payment terms.
      /// Draft orders are useful for merchants that need to:
      ///
      /// - Create new orders for sales made by phone, in person, by chat, or elsewhere. When a merchant accepts payment for a draft order, an order is created.
      /// - Send invoices to customers with a secure checkout link.
      /// - Use custom items to represent additional costs or products not in inventory.
      /// - Re-create orders manually from active sales channels.
      /// - Sell products at discount or wholesale rates.
      /// - Take pre-orders.
      ///
      /// After creating a draft order, you can:
      /// - Send an invoice to the customer using the [`draftOrderInvoiceSend`](https://shopify.dev/docs/api/admin-graphql/latest/mutations/draftOrderInvoiceSend) mutation.
      /// - Complete the draft order using the [`draftOrderComplete`](https://shopify.dev/docs/api/admin-graphql/latest/mutations/draftOrderComplete) mutation.
      /// - Update the draft order using the [`draftOrderUpdate`](https://shopify.dev/docs/api/admin-graphql/latest/mutations/draftOrderUpdate) mutation.
      /// - Duplicate a draft order using the [`draftOrderDuplicate`](https://shopify.dev/docs/api/admin-graphql/latest/mutations/draftOrderDuplicate) mutation.
      /// - Delete the draft order using the [`draftOrderDelete`](https://shopify.dev/docs/api/admin-graphql/latest/mutations/draftOrderDelete) mutation.
      ///
      /// > Note:
      /// > When you create a draft order, you can't [reserve or hold inventory](https://shopify.dev/docs/apps/build/orders-fulfillment/inventory-management-apps#inventory-states) for the items in the order by default.
      /// > However, you can reserve inventory using the [`reserveInventoryUntil`](https://shopify.dev/docs/api/admin-graphql/latest/mutations/draftOrderCreate#arguments-input.fields.reserveInventoryUntil) input.
      public var draftOrderCreate: DraftOrderCreate? { __data["draftOrderCreate"] }

      /// DraftOrderCreate
      ///
      /// Parent Type: `DraftOrderCreatePayload`
      public struct DraftOrderCreate: ShopifyAdminAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { ShopifyAdminAPI.Objects.DraftOrderCreatePayload }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("draftOrder", DraftOrder?.self),
          .field("userErrors", [UserError].self),
        ] }

        /// The created draft order.
        public var draftOrder: DraftOrder? { __data["draftOrder"] }
        /// The list of errors that occurred from executing the mutation.
        public var userErrors: [UserError] { __data["userErrors"] }

        /// DraftOrderCreate.DraftOrder
        ///
        /// Parent Type: `DraftOrder`
        public struct DraftOrder: ShopifyAdminAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { ShopifyAdminAPI.Objects.DraftOrder }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ShopifyAdminAPI.ID.self),
          ] }

          /// A globally-unique ID.
          public var id: ShopifyAdminAPI.ID { __data["id"] }
        }

        /// DraftOrderCreate.UserError
        ///
        /// Parent Type: `UserError`
        public struct UserError: ShopifyAdminAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { ShopifyAdminAPI.Objects.UserError }
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