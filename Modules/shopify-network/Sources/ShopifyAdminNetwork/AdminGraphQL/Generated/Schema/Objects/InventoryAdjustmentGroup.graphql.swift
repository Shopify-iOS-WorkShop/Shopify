// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI.Objects {
  /// Records a batch of inventory changes made together in a single operation. Tracks which [`App`](https://shopify.dev/docs/api/admin-graphql/latest/objects/App) or [`StaffMember`](https://shopify.dev/docs/api/admin-graphql/latest/objects/StaffMember) initiated the changes, when they occurred, and why they were made.
  ///
  /// Provides an audit trail through its reason and reference document URI. The reference document URI links to the source that triggered the adjustment, such as an [`Order`](https://shopify.dev/docs/api/admin-graphql/latest/objects/Order), [`InventoryTransfer`](https://shopify.dev/docs/api/admin-graphql/latest/objects/InventoryTransfer), or external system event. Use the [`changes`](https://shopify.dev/docs/api/admin-graphql/latest/objects/InventoryAdjustmentGroup#field-InventoryAdjustmentGroup.fields.changes) field to retrieve the specific quantity adjustments for each inventory state at affected [locations](https://shopify.dev/docs/api/admin-graphql/latest/objects/Location).
  static let InventoryAdjustmentGroup = ApolloAPI.Object(
    typename: "InventoryAdjustmentGroup",
    implementedInterfaces: [ShopifyAdminAPI.Interfaces.Node.self]
  )
}