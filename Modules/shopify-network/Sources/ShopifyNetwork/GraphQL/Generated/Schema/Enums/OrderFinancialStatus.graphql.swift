// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAPI {
  /// Represents the order's current financial status.
  enum OrderFinancialStatus: String, EnumType {
    /// Displayed as **Pending**.
    case pending = "PENDING"
    /// Displayed as **Authorized**.
    case authorized = "AUTHORIZED"
    /// Displayed as **Partially paid**.
    case partiallyPaid = "PARTIALLY_PAID"
    /// Displayed as **Partially refunded**.
    case partiallyRefunded = "PARTIALLY_REFUNDED"
    /// Displayed as **Voided**.
    case voided = "VOIDED"
    /// Displayed as **Paid**.
    case paid = "PAID"
    /// Displayed as **Refunded**.
    case refunded = "REFUNDED"
  }

}