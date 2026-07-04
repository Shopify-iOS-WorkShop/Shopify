// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

extension CartAPI {
  nonisolated struct MoneyFragment: CartAPI.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment MoneyFragment on MoneyV2 { __typename amount currencyCode }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { CartAPI.Objects.MoneyV2 }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("amount", CartAPI.Decimal.self),
      .field("currencyCode", GraphQLEnum<CartAPI.CurrencyCode>.self),
    ] }
    static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      MoneyFragment.self
    ] }

    /// Decimal money amount.
    var amount: CartAPI.Decimal { __data["amount"] }
    /// Currency of the money.
    var currencyCode: GraphQLEnum<CartAPI.CurrencyCode> { __data["currencyCode"] }
  }

}