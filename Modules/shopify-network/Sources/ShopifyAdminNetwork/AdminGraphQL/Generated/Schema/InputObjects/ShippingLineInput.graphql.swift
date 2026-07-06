// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI {
  /// The input fields for specifying the shipping details for the draft order.
  ///
  /// > Note:
  /// > A custom shipping line includes a title and price with `shippingRateHandle` set to `nil`. A shipping line with a carrier-provided shipping rate (currently set via the Shopify admin) includes the shipping rate handle.
  struct ShippingLineInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      priceWithCurrency: GraphQLNullable<MoneyInput> = nil,
      shippingRateHandle: GraphQLNullable<String> = nil,
      title: GraphQLNullable<String> = nil
    ) {
      __data = InputDict([
        "priceWithCurrency": priceWithCurrency,
        "shippingRateHandle": shippingRateHandle,
        "title": title
      ])
    }

    /// Price of the shipping rate with currency. If provided, `price` will be ignored.
    public var priceWithCurrency: GraphQLNullable<MoneyInput> {
      get { __data["priceWithCurrency"] }
      set { __data["priceWithCurrency"] = newValue }
    }

    /// A unique identifier for the shipping rate.
    public var shippingRateHandle: GraphQLNullable<String> {
      get { __data["shippingRateHandle"] }
      set { __data["shippingRateHandle"] = newValue }
    }

    /// Title of the shipping rate.
    public var title: GraphQLNullable<String> {
      get { __data["title"] }
      set { __data["title"] = newValue }
    }
  }

}