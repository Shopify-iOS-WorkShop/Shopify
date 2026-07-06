// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension ShopifyAPI {
  struct MoneyFragment: ShopifyAPI.SelectionSet, Fragment {
    public static var fragmentDefinition: StaticString {
      #"fragment MoneyFragment on MoneyV2 { __typename amount currencyCode }"#
    }

    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MoneyV2 }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("amount", ShopifyAPI.Decimal.self),
      .field("currencyCode", GraphQLEnum<ShopifyAPI.CurrencyCode>.self),
    ] }

    /// Decimal money amount.
    public var amount: ShopifyAPI.Decimal { __data["amount"] }
    /// Currency of the money.
    public var currencyCode: GraphQLEnum<ShopifyAPI.CurrencyCode> { __data["currencyCode"] }
  }

}