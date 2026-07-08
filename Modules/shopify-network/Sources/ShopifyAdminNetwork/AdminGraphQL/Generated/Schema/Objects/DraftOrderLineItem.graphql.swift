// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// A line item in a draft order. Line items are either [`ProductVariant`](https://shopify.dev/docs/api/admin-graphql/latest/objects/ProductVariant) objects or custom items created manually with specific pricing and attributes.
  ///
  /// Each line item includes [quantity](https://shopify.dev/docs/api/admin-graphql/latest/objects/DraftOrderLineItem#field-DraftOrderLineItem.fields.quantity), [pricing](https://shopify.dev/docs/api/admin-graphql/latest/objects/DraftOrderLineItem#field-DraftOrderLineItem.fields.originalUnitPrice), [discounts](https://shopify.dev/docs/api/admin-graphql/latest/objects/DraftOrderLineItem#field-DraftOrderLineItem.fields.discountedTotal), [tax information](https://shopify.dev/docs/api/admin-graphql/latest/objects/DraftOrderLineItem#field-DraftOrderLineItem.fields.taxLines), and [custom attributes](https://shopify.dev/docs/api/admin-graphql/latest/objects/DraftOrderLineItem#field-DraftOrderLineItem.fields.customAttributes). For [bundle products](https://shopify.dev/docs/apps/build/products/bundles), the line item includes components that define the individual products within the bundle.
  static let DraftOrderLineItem = ApolloAPI.Object(
    typename: "DraftOrderLineItem",
    implementedInterfaces: [ShopifyAdminAPI.Interfaces.Node.self]
  )
}