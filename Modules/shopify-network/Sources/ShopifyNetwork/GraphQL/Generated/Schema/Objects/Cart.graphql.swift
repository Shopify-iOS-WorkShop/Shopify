// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAPI.Objects {
  /// A cart represents the merchandise that a buyer intends to purchase, and the estimated cost associated with the cart, throughout a customer's session.
  ///
  /// Use the [`checkoutUrl`](https://shopify.dev/docs/api/storefront/current/objects/Cart#field-checkoutUrl) field to direct buyers to Shopify's web checkout to complete their purchase.
  ///
  /// Learn more about [interacting with carts](https://shopify.dev/docs/storefronts/headless/building-with-the-storefront-api/cart/manage).
  ///
  static let Cart = ApolloAPI.Object(
    typename: "Cart",
    implementedInterfaces: [
      ShopifyAPI.Interfaces.HasMetafields.self,
      ShopifyAPI.Interfaces.Node.self
    ]
  )
}