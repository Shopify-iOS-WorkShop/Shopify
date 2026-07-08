// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// <div class="note"><h4>Theme app extensions</h4>
  ///   <p>If your app integrates with a Shopify theme and you plan to submit it to the Shopify App Store, you must use theme app extensions instead of Script tags. Script tags can only be used with vintage themes. <a href="/apps/online-store#what-integration-method-should-i-use" target="_blank">Learn more</a>.</p></div>
  ///
  /// <div class="note"><h4>Script tag deprecation</h4>
  ///   <p>Script tags will be sunset for the <b>Order status</b> page on August 28, 2025. <a href="https://www.shopify.com/plus/upgrading-to-checkout-extensibility">Upgrade to Checkout Extensibility</a> before this date. <a href="/docs/api/liquid/objects#script">Shopify Scripts</a> will continue to work alongside Checkout Extensibility until August 28, 2025.</p></div>
  ///
  ///
  /// A script tag represents remote JavaScript code that is loaded into the pages of a shop's storefront or the **Order status** page of checkout.
  static let ScriptTag = ApolloAPI.Object(
    typename: "ScriptTag",
    implementedInterfaces: [
      ShopifyAdminAPI.Interfaces.LegacyInteroperability.self,
      ShopifyAdminAPI.Interfaces.Node.self
    ]
  )
}