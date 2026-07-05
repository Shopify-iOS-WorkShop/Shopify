// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

nonisolated protocol CartAPI_SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == CartAPI.SchemaMetadata {}

nonisolated protocol CartAPI_InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == CartAPI.SchemaMetadata {}

nonisolated protocol CartAPI_MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == CartAPI.SchemaMetadata {}

nonisolated protocol CartAPI_MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == CartAPI.SchemaMetadata {}

extension CartAPI {
  typealias SelectionSet = CartAPI_SelectionSet

  typealias InlineFragment = CartAPI_InlineFragment

  typealias MutableSelectionSet = CartAPI_MutableSelectionSet

  typealias MutableInlineFragment = CartAPI_MutableInlineFragment

  nonisolated enum SchemaMetadata: ApolloAPI.SchemaMetadata {
    static let configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

    private static let objectTypeMap: [String: ApolloAPI.Object] = [
      "AppliedGiftCard": CartAPI.Objects.AppliedGiftCard,
      "Article": CartAPI.Objects.Article,
      "BaseCartLineConnection": CartAPI.Objects.BaseCartLineConnection,
      "Blog": CartAPI.Objects.Blog,
      "Cart": CartAPI.Objects.Cart,
      "CartAutomaticDiscountAllocation": CartAPI.Objects.CartAutomaticDiscountAllocation,
      "CartBuyerIdentity": CartAPI.Objects.CartBuyerIdentity,
      "CartBuyerIdentityUpdatePayload": CartAPI.Objects.CartBuyerIdentityUpdatePayload,
      "CartCodeDiscountAllocation": CartAPI.Objects.CartCodeDiscountAllocation,
      "CartCost": CartAPI.Objects.CartCost,
      "CartCreatePayload": CartAPI.Objects.CartCreatePayload,
      "CartCustomDiscountAllocation": CartAPI.Objects.CartCustomDiscountAllocation,
      "CartDiscountCode": CartAPI.Objects.CartDiscountCode,
      "CartDiscountCodesUpdatePayload": CartAPI.Objects.CartDiscountCodesUpdatePayload,
      "CartLine": CartAPI.Objects.CartLine,
      "CartLineCost": CartAPI.Objects.CartLineCost,
      "CartLinesAddPayload": CartAPI.Objects.CartLinesAddPayload,
      "CartLinesRemovePayload": CartAPI.Objects.CartLinesRemovePayload,
      "CartLinesUpdatePayload": CartAPI.Objects.CartLinesUpdatePayload,
      "CartUserError": CartAPI.Objects.CartUserError,
      "Collection": CartAPI.Objects.Collection,
      "Comment": CartAPI.Objects.Comment,
      "Company": CartAPI.Objects.Company,
      "CompanyContact": CartAPI.Objects.CompanyContact,
      "CompanyLocation": CartAPI.Objects.CompanyLocation,
      "ComponentizableCartLine": CartAPI.Objects.ComponentizableCartLine,
      "Customer": CartAPI.Objects.Customer,
      "CustomerUserError": CartAPI.Objects.CustomerUserError,
      "ExternalVideo": CartAPI.Objects.ExternalVideo,
      "GenericFile": CartAPI.Objects.GenericFile,
      "Image": CartAPI.Objects.Image,
      "Location": CartAPI.Objects.Location,
      "MailingAddress": CartAPI.Objects.MailingAddress,
      "Market": CartAPI.Objects.Market,
      "MediaImage": CartAPI.Objects.MediaImage,
      "MediaPresentation": CartAPI.Objects.MediaPresentation,
      "Menu": CartAPI.Objects.Menu,
      "MenuItem": CartAPI.Objects.MenuItem,
      "Metafield": CartAPI.Objects.Metafield,
      "MetafieldDeleteUserError": CartAPI.Objects.MetafieldDeleteUserError,
      "MetafieldsSetUserError": CartAPI.Objects.MetafieldsSetUserError,
      "Metaobject": CartAPI.Objects.Metaobject,
      "Model3d": CartAPI.Objects.Model3d,
      "MoneyV2": CartAPI.Objects.MoneyV2,
      "Mutation": CartAPI.Objects.Mutation,
      "Order": CartAPI.Objects.Order,
      "Page": CartAPI.Objects.Page,
      "Product": CartAPI.Objects.Product,
      "ProductOption": CartAPI.Objects.ProductOption,
      "ProductOptionValue": CartAPI.Objects.ProductOptionValue,
      "ProductVariant": CartAPI.Objects.ProductVariant,
      "QueryRoot": CartAPI.Objects.QueryRoot,
      "SearchQuerySuggestion": CartAPI.Objects.SearchQuerySuggestion,
      "SelectedOption": CartAPI.Objects.SelectedOption,
      "SellingPlan": CartAPI.Objects.SellingPlan,
      "Shop": CartAPI.Objects.Shop,
      "ShopPayInstallmentsFinancingPlan": CartAPI.Objects.ShopPayInstallmentsFinancingPlan,
      "ShopPayInstallmentsFinancingPlanTerm": CartAPI.Objects.ShopPayInstallmentsFinancingPlanTerm,
      "ShopPayInstallmentsProductVariantPricing": CartAPI.Objects.ShopPayInstallmentsProductVariantPricing,
      "ShopPolicy": CartAPI.Objects.ShopPolicy,
      "TaxonomyCategory": CartAPI.Objects.TaxonomyCategory,
      "UrlRedirect": CartAPI.Objects.UrlRedirect,
      "UserError": CartAPI.Objects.UserError,
      "UserErrorsShopPayPaymentRequestSessionUserErrors": CartAPI.Objects.UserErrorsShopPayPaymentRequestSessionUserErrors,
      "Video": CartAPI.Objects.Video
    ]

    static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
      objectTypeMap[typename]
    }
  }

  nonisolated enum Objects {}
  nonisolated enum Interfaces {}
  nonisolated enum Unions {}

}