// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// The central configuration and settings hub for a Shopify store. Access business information, operational preferences, feature availability, and store-wide settings that control how the shop operates.
  ///
  /// Includes core business details like the shop name, contact emails, billing address, and currency settings. The shop configuration determines customer account requirements, available sales channels, enabled features, payment settings, and policy documents. Also provides access to shop-level resources such as staff members, fulfillment services, navigation settings, and storefront access tokens.
  static let Shop = ApolloAPI.Object(
    typename: "Shop",
    implementedInterfaces: [
      ShopifyAdminAPI.Interfaces.HasMetafieldDefinitions.self,
      ShopifyAdminAPI.Interfaces.HasMetafields.self,
      ShopifyAdminAPI.Interfaces.HasPublishedTranslations.self,
      ShopifyAdminAPI.Interfaces.Node.self
    ]
  )
}