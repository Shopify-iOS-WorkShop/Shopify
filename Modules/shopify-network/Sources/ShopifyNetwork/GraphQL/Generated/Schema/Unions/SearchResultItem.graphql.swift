// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAPI.Unions {
  /// A search result that matches the search query.
  ///
  nonisolated static let SearchResultItem = Union(
    name: "SearchResultItem",
    possibleTypes: [
      ShopifyAPI.Objects.Article.self,
      ShopifyAPI.Objects.Page.self,
      ShopifyAPI.Objects.Product.self
    ]
  )
}