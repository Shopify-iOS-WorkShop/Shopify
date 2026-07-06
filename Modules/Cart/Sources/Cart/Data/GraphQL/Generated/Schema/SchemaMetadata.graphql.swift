// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

protocol CartAPI_SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == CartAPI.SchemaMetadata {}

protocol CartAPI_InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == CartAPI.SchemaMetadata {}

protocol CartAPI_MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == CartAPI.SchemaMetadata {}

protocol CartAPI_MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == CartAPI.SchemaMetadata {}

extension CartAPI {
  typealias ID = String

  typealias SelectionSet = CartAPI_SelectionSet

  typealias InlineFragment = CartAPI_InlineFragment

  typealias MutableSelectionSet = CartAPI_MutableSelectionSet

  typealias MutableInlineFragment = CartAPI_MutableInlineFragment

  enum SchemaMetadata: ApolloAPI.SchemaMetadata {
    static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

    static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
      switch typename {
      case "Mutation": return CartAPI.Objects.Mutation
      case "CartLinesAddPayload": return CartAPI.Objects.CartLinesAddPayload
      case "Cart": return CartAPI.Objects.Cart
      case "Article": return CartAPI.Objects.Article
      case "AppliedGiftCard": return CartAPI.Objects.AppliedGiftCard
      case "Blog": return CartAPI.Objects.Blog
      case "Collection": return CartAPI.Objects.Collection
      case "Page": return CartAPI.Objects.Page
      case "Product": return CartAPI.Objects.Product
      case "SearchQuerySuggestion": return CartAPI.Objects.SearchQuerySuggestion
      case "Metaobject": return CartAPI.Objects.Metaobject
      case "CartLine": return CartAPI.Objects.CartLine
      case "ComponentizableCartLine": return CartAPI.Objects.ComponentizableCartLine
      case "Comment": return CartAPI.Objects.Comment
      case "Company": return CartAPI.Objects.Company
      case "CompanyContact": return CartAPI.Objects.CompanyContact
      case "CompanyLocation": return CartAPI.Objects.CompanyLocation
      case "ExternalVideo": return CartAPI.Objects.ExternalVideo
      case "MediaImage": return CartAPI.Objects.MediaImage
      case "Model3d": return CartAPI.Objects.Model3d
      case "Video": return CartAPI.Objects.Video
      case "GenericFile": return CartAPI.Objects.GenericFile
      case "Location": return CartAPI.Objects.Location
      case "MailingAddress": return CartAPI.Objects.MailingAddress
      case "Market": return CartAPI.Objects.Market
      case "MediaPresentation": return CartAPI.Objects.MediaPresentation
      case "Menu": return CartAPI.Objects.Menu
      case "MenuItem": return CartAPI.Objects.MenuItem
      case "Metafield": return CartAPI.Objects.Metafield
      case "Order": return CartAPI.Objects.Order
      case "ProductOption": return CartAPI.Objects.ProductOption
      case "ProductOptionValue": return CartAPI.Objects.ProductOptionValue
      case "ProductVariant": return CartAPI.Objects.ProductVariant
      case "Shop": return CartAPI.Objects.Shop
      case "ShopPayInstallmentsFinancingPlan": return CartAPI.Objects.ShopPayInstallmentsFinancingPlan
      case "ShopPayInstallmentsFinancingPlanTerm": return CartAPI.Objects.ShopPayInstallmentsFinancingPlanTerm
      case "ShopPayInstallmentsProductVariantPricing": return CartAPI.Objects.ShopPayInstallmentsProductVariantPricing
      case "ShopPolicy": return CartAPI.Objects.ShopPolicy
      case "TaxonomyCategory": return CartAPI.Objects.TaxonomyCategory
      case "UrlRedirect": return CartAPI.Objects.UrlRedirect
      case "Customer": return CartAPI.Objects.Customer
      case "SellingPlan": return CartAPI.Objects.SellingPlan
      case "BaseCartLineConnection": return CartAPI.Objects.BaseCartLineConnection
      case "MoneyV2": return CartAPI.Objects.MoneyV2
      case "Image": return CartAPI.Objects.Image
      case "SelectedOption": return CartAPI.Objects.SelectedOption
      case "CartLineCost": return CartAPI.Objects.CartLineCost
      case "CartAutomaticDiscountAllocation": return CartAPI.Objects.CartAutomaticDiscountAllocation
      case "CartCodeDiscountAllocation": return CartAPI.Objects.CartCodeDiscountAllocation
      case "CartCustomDiscountAllocation": return CartAPI.Objects.CartCustomDiscountAllocation
      case "CartCost": return CartAPI.Objects.CartCost
      case "CartDiscountCode": return CartAPI.Objects.CartDiscountCode
      case "CartBuyerIdentity": return CartAPI.Objects.CartBuyerIdentity
      case "CartUserError": return CartAPI.Objects.CartUserError
      case "CustomerUserError": return CartAPI.Objects.CustomerUserError
      case "MetafieldDeleteUserError": return CartAPI.Objects.MetafieldDeleteUserError
      case "MetafieldsSetUserError": return CartAPI.Objects.MetafieldsSetUserError
      case "UserError": return CartAPI.Objects.UserError
      case "UserErrorsShopPayPaymentRequestSessionUserErrors": return CartAPI.Objects.UserErrorsShopPayPaymentRequestSessionUserErrors
      case "CartBuyerIdentityUpdatePayload": return CartAPI.Objects.CartBuyerIdentityUpdatePayload
      case "CartLinesRemovePayload": return CartAPI.Objects.CartLinesRemovePayload
      case "CartLinesUpdatePayload": return CartAPI.Objects.CartLinesUpdatePayload
      case "CartCreatePayload": return CartAPI.Objects.CartCreatePayload
      case "CartDiscountCodesUpdatePayload": return CartAPI.Objects.CartDiscountCodesUpdatePayload
      case "QueryRoot": return CartAPI.Objects.QueryRoot
      default: return nil
      }
    }
  }

  enum Objects {}
  enum Interfaces {}
  enum Unions {}

}