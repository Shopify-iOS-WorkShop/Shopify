// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI {
  /// The input fields for a monetary value with currency.
  struct MoneyInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      amount: Decimal,
      currencyCode: GraphQLEnum<CurrencyCode>
    ) {
      __data = InputDict([
        "amount": amount,
        "currencyCode": currencyCode
      ])
    }

    /// Decimal money amount.
    public var amount: Decimal {
      get { __data["amount"] }
      set { __data["amount"] = newValue }
    }

    /// Currency of the money.
    public var currencyCode: GraphQLEnum<CurrencyCode> {
      get { __data["currencyCode"] }
      set { __data["currencyCode"] = newValue }
    }
  }

}