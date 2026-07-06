// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI {
  /// The input fields for applying an order-level discount to a draft order.
  struct DraftOrderAppliedDiscountInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      amountWithCurrency: GraphQLNullable<MoneyInput> = nil,
      description: GraphQLNullable<String> = nil,
      title: GraphQLNullable<String> = nil,
      value: Double,
      valueType: GraphQLEnum<DraftOrderAppliedDiscountType>
    ) {
      __data = InputDict([
        "amountWithCurrency": amountWithCurrency,
        "description": description,
        "title": title,
        "value": value,
        "valueType": valueType
      ])
    }

    /// The applied amount of the discount in the specified currency.
    public var amountWithCurrency: GraphQLNullable<MoneyInput> {
      get { __data["amountWithCurrency"] }
      set { __data["amountWithCurrency"] = newValue }
    }

    /// Reason for the discount.
    public var description: GraphQLNullable<String> {
      get { __data["description"] }
      set { __data["description"] = newValue }
    }

    /// Title of the discount.
    public var title: GraphQLNullable<String> {
      get { __data["title"] }
      set { __data["title"] = newValue }
    }

    /// The value of the discount.
    /// If the type of the discount is fixed amount, then this is a fixed amount in your shop currency.
    /// If the type is percentage, then this is the percentage.
    public var value: Double {
      get { __data["value"] }
      set { __data["value"] = newValue }
    }

    /// The type of discount.
    public var valueType: GraphQLEnum<DraftOrderAppliedDiscountType> {
      get { __data["valueType"] }
      set { __data["valueType"] = newValue }
    }
  }

}