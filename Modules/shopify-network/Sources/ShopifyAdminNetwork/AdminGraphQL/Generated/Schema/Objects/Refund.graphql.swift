// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// The `Refund` object represents a financial record of money returned to a customer from an order.
  /// It provides a comprehensive view of all refunded amounts, transactions, and restocking instructions
  /// associated with returning products or correcting order issues.
  ///
  /// The `Refund` object provides information to:
  ///
  /// - Process customer returns and issue payments back to customers
  /// - Handle partial or full refunds for line items with optional inventory restocking
  /// - Refund shipping costs, duties, and additional fees
  /// - Issue store credit refunds as an alternative to original payment method returns
  /// - Track and reconcile all financial transactions related to refunds
  ///
  /// Each `Refund` object maintains detailed records of what was refunded, how much was refunded,
  /// which payment transactions were involved, and any inventory restocking that occurred. The refund
  /// can include multiple components such as product line items, shipping charges, taxes, duties, and
  /// additional fees, all calculated with proper currency handling for international orders.
  ///
  /// Refunds are always associated with an [order](https://shopify.dev/docs/api/admin-graphql/latest/objects/Order)
  /// and can optionally be linked to a [return](https://shopify.dev/docs/api/admin-graphql/latest/objects/Return)
  /// if the refund was initiated through the returns process. The refund tracks both the presentment currency
  /// (what the customer sees) and the shop currency for accurate financial reporting.
  ///
  /// > Note:
  /// > The existence of a `Refund` object doesn't guarantee that the money has been returned to the customer.
  /// > The actual financial processing happens through associated
  /// > [`OrderTransaction`](https://shopify.dev/docs/api/admin-graphql/latest/objects/OrderTransaction)
  /// > objects, which can be in various states, such as pending, processing, success, or failure.
  /// > To determine if money has actually been refunded, check the
  /// > [status](https://shopify.dev/docs/api/admin-graphql/latest/objects/OrderTransaction#field-OrderTransaction.fields.status)
  /// > of the associated transactions.
  ///
  /// Learn more about
  /// [managing returns](https://shopify.dev/docs/apps/build/orders-fulfillment/returns-apps/build-return-management),
  /// [refunding duties](https://shopify.dev/docs/apps/build/orders-fulfillment/returns-apps/view-and-refund-duties), and
  /// [processing refunds](https://shopify.dev/docs/api/admin-graphql/latest/mutations/refundCreate).
  static let Refund = ApolloAPI.Object(
    typename: "Refund",
    implementedInterfaces: [
      ShopifyAdminAPI.Interfaces.LegacyInteroperability.self,
      ShopifyAdminAPI.Interfaces.Node.self
    ]
  )
}