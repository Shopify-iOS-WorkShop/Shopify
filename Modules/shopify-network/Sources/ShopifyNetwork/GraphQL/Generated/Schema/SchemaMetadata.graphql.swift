// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

nonisolated public protocol ShopifyAPI_SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == ShopifyAPI.SchemaMetadata {}

nonisolated public protocol ShopifyAPI_InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == ShopifyAPI.SchemaMetadata {}

nonisolated public protocol ShopifyAPI_MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == ShopifyAPI.SchemaMetadata {}

nonisolated public protocol ShopifyAPI_MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == ShopifyAPI.SchemaMetadata {}

public extension ShopifyAPI {
  typealias SelectionSet = ShopifyAPI_SelectionSet

  typealias InlineFragment = ShopifyAPI_InlineFragment

  typealias MutableSelectionSet = ShopifyAPI_MutableSelectionSet

  typealias MutableInlineFragment = ShopifyAPI_MutableInlineFragment

  nonisolated enum SchemaMetadata: ApolloAPI.SchemaMetadata {
    public static let configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

    private static let objectTypeMap: [String: ApolloAPI.Object] = [
      "AppliedGiftCard": ShopifyAPI.Objects.AppliedGiftCard,
      "Article": ShopifyAPI.Objects.Article,
      "Blog": ShopifyAPI.Objects.Blog,
      "Cart": ShopifyAPI.Objects.Cart,
      "CartLine": ShopifyAPI.Objects.CartLine,
      "Collection": ShopifyAPI.Objects.Collection,
      "Comment": ShopifyAPI.Objects.Comment,
      "Company": ShopifyAPI.Objects.Company,
      "CompanyContact": ShopifyAPI.Objects.CompanyContact,
      "CompanyLocation": ShopifyAPI.Objects.CompanyLocation,
      "ComponentizableCartLine": ShopifyAPI.Objects.ComponentizableCartLine,
      "Customer": ShopifyAPI.Objects.Customer,
      "ExternalVideo": ShopifyAPI.Objects.ExternalVideo,
      "GenericFile": ShopifyAPI.Objects.GenericFile,
      "Image": ShopifyAPI.Objects.Image,
      "ImageConnection": ShopifyAPI.Objects.ImageConnection,
      "ImageEdge": ShopifyAPI.Objects.ImageEdge,
      "Location": ShopifyAPI.Objects.Location,
      "MailingAddress": ShopifyAPI.Objects.MailingAddress,
      "Market": ShopifyAPI.Objects.Market,
      "MediaImage": ShopifyAPI.Objects.MediaImage,
      "MediaPresentation": ShopifyAPI.Objects.MediaPresentation,
      "Menu": ShopifyAPI.Objects.Menu,
      "MenuItem": ShopifyAPI.Objects.MenuItem,
      "Metafield": ShopifyAPI.Objects.Metafield,
      "Metaobject": ShopifyAPI.Objects.Metaobject,
      "Model3d": ShopifyAPI.Objects.Model3d,
      "MoneyV2": ShopifyAPI.Objects.MoneyV2,
      "Order": ShopifyAPI.Objects.Order,
      "Page": ShopifyAPI.Objects.Page,
      "PageInfo": ShopifyAPI.Objects.PageInfo,
      "PredictiveSearchResult": ShopifyAPI.Objects.PredictiveSearchResult,
      "Product": ShopifyAPI.Objects.Product,
      "ProductOption": ShopifyAPI.Objects.ProductOption,
      "ProductOptionValue": ShopifyAPI.Objects.ProductOptionValue,
      "ProductPriceRange": ShopifyAPI.Objects.ProductPriceRange,
      "ProductVariant": ShopifyAPI.Objects.ProductVariant,
      "ProductVariantConnection": ShopifyAPI.Objects.ProductVariantConnection,
      "ProductVariantEdge": ShopifyAPI.Objects.ProductVariantEdge,
      "QueryRoot": ShopifyAPI.Objects.QueryRoot,
      "SearchQuerySuggestion": ShopifyAPI.Objects.SearchQuerySuggestion,
      "SearchResultItemConnection": ShopifyAPI.Objects.SearchResultItemConnection,
      "SearchResultItemEdge": ShopifyAPI.Objects.SearchResultItemEdge,
      "SellingPlan": ShopifyAPI.Objects.SellingPlan,
      "Shop": ShopifyAPI.Objects.Shop,
      "ShopPayInstallmentsFinancingPlan": ShopifyAPI.Objects.ShopPayInstallmentsFinancingPlan,
      "ShopPayInstallmentsFinancingPlanTerm": ShopifyAPI.Objects.ShopPayInstallmentsFinancingPlanTerm,
      "ShopPayInstallmentsProductVariantPricing": ShopifyAPI.Objects.ShopPayInstallmentsProductVariantPricing,
      "ShopPolicy": ShopifyAPI.Objects.ShopPolicy,
      "TaxonomyCategory": ShopifyAPI.Objects.TaxonomyCategory,
      "UrlRedirect": ShopifyAPI.Objects.UrlRedirect,
      "Video": ShopifyAPI.Objects.Video
    ]

    @_spi(Execution) public static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
      objectTypeMap[typename]
    }
  }

  nonisolated enum Objects {}
  nonisolated enum Interfaces {}
  nonisolated enum Unions {}

}