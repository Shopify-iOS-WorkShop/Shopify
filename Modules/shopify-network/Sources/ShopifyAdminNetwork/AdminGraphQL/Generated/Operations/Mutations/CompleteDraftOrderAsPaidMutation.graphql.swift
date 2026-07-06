// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension ShopifyAdminAPI {
  class CompleteDraftOrderAsPaidMutation: GraphQLMutation {
    public static let operationName: String = "CompleteDraftOrderAsPaid"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation CompleteDraftOrderAsPaid($id: ID!) { draftOrderComplete(id: $id) { __typename draftOrder { __typename order { __typename id name } } userErrors { __typename message } } }"#
      ))

    public var id: ID

    public init(id: ID) {
      self.id = id
    }

    public var __variables: Variables? { ["id": id] }

    public struct Data: ShopifyAdminAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAdminAPI.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("draftOrderComplete", DraftOrderComplete?.self, arguments: ["id": .variable("id")]),
      ] }

      /// Completes a [draft order](https://shopify.dev/docs/api/admin-graphql/latest/objects/DraftOrder) and
      /// converts it into a [regular order](https://shopify.dev/docs/api/admin-graphql/latest/objects/Order).
      /// The order appears in the merchant's orders list, and the customer can be notified about their order.
      ///
      /// Use the `draftOrderComplete` mutation when a merchant is ready to finalize a draft order and create a real
      /// order in their store. The `draftOrderComplete` mutation also supports sales channel attribution for tracking
      /// order sources using the [`sourceName`](https://shopify.dev/docs/api/admin-graphql/latest/mutations/draftOrderComplete#arguments-sourceName)
      /// argument, [cart validation](https://shopify.dev/docs/apps/build/checkout/cart-checkout-validation)
      /// controls for app integrations, and detailed error reporting for failed completions.
      ///
      /// You can complete a draft order with different [payment scenarios](https://help.shopify.com/manual/fulfillment/managing-orders/payments):
      ///
      /// - Mark the order as paid immediately.
      /// - Set the order as payment pending using [payment terms](https://shopify.dev/docs/api/admin-graphql/latest/objects/PaymentTerms).
      /// - Specify a custom payment amount.
      /// - Select a specific payment gateway.
      ///
      /// > Note:
      /// > When completing a draft order, inventory is [reserved](https://shopify.dev/docs/apps/build/orders-fulfillment/inventory-management-apps#inventory-states)
      /// for the items in the order. This means the items will no longer be available for other customers to purchase.
      /// Make sure to verify inventory availability before completing the draft order.
      public var draftOrderComplete: DraftOrderComplete? { __data["draftOrderComplete"] }

      /// DraftOrderComplete
      ///
      /// Parent Type: `DraftOrderCompletePayload`
      public struct DraftOrderComplete: ShopifyAdminAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { ShopifyAdminAPI.Objects.DraftOrderCompletePayload }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("draftOrder", DraftOrder?.self),
          .field("userErrors", [UserError].self),
        ] }

        /// The completed draft order.
        public var draftOrder: DraftOrder? { __data["draftOrder"] }
        /// The list of errors that occurred from executing the mutation.
        public var userErrors: [UserError] { __data["userErrors"] }

        /// DraftOrderComplete.DraftOrder
        ///
        /// Parent Type: `DraftOrder`
        public struct DraftOrder: ShopifyAdminAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { ShopifyAdminAPI.Objects.DraftOrder }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("order", Order?.self),
          ] }

          /// The order that was created from the draft order.
          public var order: Order? { __data["order"] }

          /// DraftOrderComplete.DraftOrder.Order
          ///
          /// Parent Type: `Order`
          public struct Order: ShopifyAdminAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { ShopifyAdminAPI.Objects.Order }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("id", ShopifyAdminAPI.ID.self),
              .field("name", String.self),
            ] }

            /// A globally-unique ID.
            public var id: ShopifyAdminAPI.ID { __data["id"] }
            /// The unique identifier for the order that appears on the order page in the Shopify admin and the **Order status** page.
            /// For example, "#1001", "EN1001", or "1001-A".
            /// This value isn't unique across multiple stores. Use this field to identify orders in the Shopify admin and for order tracking.
            public var name: String { __data["name"] }
          }
        }

        /// DraftOrderComplete.UserError
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