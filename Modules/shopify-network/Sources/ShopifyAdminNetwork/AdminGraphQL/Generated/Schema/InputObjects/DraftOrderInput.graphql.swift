// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI {
  /// The input fields used to create or update a draft order.
  struct DraftOrderInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      appliedDiscount: GraphQLNullable<DraftOrderAppliedDiscountInput> = nil,
      discountCodes: GraphQLNullable<[String]> = nil,
      acceptAutomaticDiscounts: GraphQLNullable<Bool> = nil,
      billingAddress: GraphQLNullable<MailingAddressInput> = nil,
      customAttributes: GraphQLNullable<[AttributeInput]> = nil,
      email: GraphQLNullable<String> = nil,
      lineItems: GraphQLNullable<[DraftOrderLineItemInput]> = nil,
      metafields: GraphQLNullable<[MetafieldInput]> = nil,
      localizedFields: GraphQLNullable<[LocalizedFieldInput]> = nil,
      note: GraphQLNullable<String> = nil,
      shippingAddress: GraphQLNullable<MailingAddressInput> = nil,
      shippingLine: GraphQLNullable<ShippingLineInput> = nil,
      tags: GraphQLNullable<[String]> = nil,
      taxExempt: GraphQLNullable<Bool> = nil,
      useCustomerDefaultAddress: GraphQLNullable<Bool> = nil,
      visibleToCustomer: GraphQLNullable<Bool> = nil,
      reserveInventoryUntil: GraphQLNullable<DateTime> = nil,
      presentmentCurrencyCode: GraphQLNullable<GraphQLEnum<CurrencyCode>> = nil,
      phone: GraphQLNullable<String> = nil,
      paymentTerms: GraphQLNullable<PaymentTermsInput> = nil,
      purchasingEntity: GraphQLNullable<PurchasingEntityInput> = nil,
      sourceName: GraphQLNullable<String> = nil,
      allowDiscountCodesInCheckout: GraphQLNullable<Bool> = nil,
      poNumber: GraphQLNullable<String> = nil,
      sessionToken: GraphQLNullable<String> = nil,
      transformerFingerprint: GraphQLNullable<String> = nil
    ) {
      __data = InputDict([
        "appliedDiscount": appliedDiscount,
        "discountCodes": discountCodes,
        "acceptAutomaticDiscounts": acceptAutomaticDiscounts,
        "billingAddress": billingAddress,
        "customAttributes": customAttributes,
        "email": email,
        "lineItems": lineItems,
        "metafields": metafields,
        "localizedFields": localizedFields,
        "note": note,
        "shippingAddress": shippingAddress,
        "shippingLine": shippingLine,
        "tags": tags,
        "taxExempt": taxExempt,
        "useCustomerDefaultAddress": useCustomerDefaultAddress,
        "visibleToCustomer": visibleToCustomer,
        "reserveInventoryUntil": reserveInventoryUntil,
        "presentmentCurrencyCode": presentmentCurrencyCode,
        "phone": phone,
        "paymentTerms": paymentTerms,
        "purchasingEntity": purchasingEntity,
        "sourceName": sourceName,
        "allowDiscountCodesInCheckout": allowDiscountCodesInCheckout,
        "poNumber": poNumber,
        "sessionToken": sessionToken,
        "transformerFingerprint": transformerFingerprint
      ])
    }

    /// The discount that will be applied to the draft order.
    /// A draft order line item can have one discount. A draft order can also have one order-level discount.
    public var appliedDiscount: GraphQLNullable<DraftOrderAppliedDiscountInput> {
      get { __data["appliedDiscount"] }
      set { __data["appliedDiscount"] = newValue }
    }

    /// The list of discount codes that will be attempted to be applied to the draft order.
    /// If the draft isn't eligible for any given discount code it will be skipped during calculation.
    public var discountCodes: GraphQLNullable<[String]> {
      get { __data["discountCodes"] }
      set { __data["discountCodes"] = newValue }
    }

    /// Whether or not to accept automatic discounts on the draft order during calculation.
    /// If false, only discount codes and custom draft order discounts (see `appliedDiscount`) will be applied.
    /// If true, eligible automatic discounts will be applied in addition to discount codes and custom draft order discounts.
    public var acceptAutomaticDiscounts: GraphQLNullable<Bool> {
      get { __data["acceptAutomaticDiscounts"] }
      set { __data["acceptAutomaticDiscounts"] = newValue }
    }

    /// The mailing address associated with the payment method.
    public var billingAddress: GraphQLNullable<MailingAddressInput> {
      get { __data["billingAddress"] }
      set { __data["billingAddress"] = newValue }
    }

    /// The extra information added to the draft order on behalf of the customer.
    public var customAttributes: GraphQLNullable<[AttributeInput]> {
      get { __data["customAttributes"] }
      set { __data["customAttributes"] = newValue }
    }

    /// The customer's email address.
    public var email: GraphQLNullable<String> {
      get { __data["email"] }
      set { __data["email"] = newValue }
    }

    /// The list of product variant or custom line item.
    /// Each draft order must include at least one line item.
    /// Accepts a maximum of 499 line items.
    ///
    /// NOTE: Draft orders don't currently support subscriptions.
    public var lineItems: GraphQLNullable<[DraftOrderLineItemInput]> {
      get { __data["lineItems"] }
      set { __data["lineItems"] = newValue }
    }

    /// The list of metafields attached to the draft order. An existing metafield can not be used when creating a draft order.
    public var metafields: GraphQLNullable<[MetafieldInput]> {
      get { __data["metafields"] }
      set { __data["metafields"] = newValue }
    }

    /// The localized fields attached to the draft order. For example, Tax IDs.
    public var localizedFields: GraphQLNullable<[LocalizedFieldInput]> {
      get { __data["localizedFields"] }
      set { __data["localizedFields"] = newValue }
    }

    /// The text of an optional note that a shop owner can attach to the draft order.
    public var note: GraphQLNullable<String> {
      get { __data["note"] }
      set { __data["note"] = newValue }
    }

    /// The mailing address to where the order will be shipped.
    public var shippingAddress: GraphQLNullable<MailingAddressInput> {
      get { __data["shippingAddress"] }
      set { __data["shippingAddress"] = newValue }
    }

    /// The shipping line object, which details the shipping method used.
    public var shippingLine: GraphQLNullable<ShippingLineInput> {
      get { __data["shippingLine"] }
      set { __data["shippingLine"] = newValue }
    }

    /// A comma separated list of tags that have been added to the draft order.
    public var tags: GraphQLNullable<[String]> {
      get { __data["tags"] }
      set { __data["tags"] = newValue }
    }

    /// Whether or not taxes are exempt for the draft order.
    /// If false, then Shopify will refer to the taxable field for each line item.
    /// If a customer is applied to the draft order, then Shopify will use the customer's tax exempt field instead.
    public var taxExempt: GraphQLNullable<Bool> {
      get { __data["taxExempt"] }
      set { __data["taxExempt"] = newValue }
    }

    /// Whether to use the customer's default address.
    public var useCustomerDefaultAddress: GraphQLNullable<Bool> {
      get { __data["useCustomerDefaultAddress"] }
      set { __data["useCustomerDefaultAddress"] = newValue }
    }

    /// Whether the draft order will be visible to the customer on the self-serve portal.
    public var visibleToCustomer: GraphQLNullable<Bool> {
      get { __data["visibleToCustomer"] }
      set { __data["visibleToCustomer"] = newValue }
    }

    /// The time after which inventory reservation will expire.
    public var reserveInventoryUntil: GraphQLNullable<DateTime> {
      get { __data["reserveInventoryUntil"] }
      set { __data["reserveInventoryUntil"] = newValue }
    }

    /// The payment currency of the customer for this draft order.
    public var presentmentCurrencyCode: GraphQLNullable<GraphQLEnum<CurrencyCode>> {
      get { __data["presentmentCurrencyCode"] }
      set { __data["presentmentCurrencyCode"] = newValue }
    }

    /// The customer's phone number.
    public var phone: GraphQLNullable<String> {
      get { __data["phone"] }
      set { __data["phone"] = newValue }
    }

    /// The fields used to create payment terms.
    public var paymentTerms: GraphQLNullable<PaymentTermsInput> {
      get { __data["paymentTerms"] }
      set { __data["paymentTerms"] = newValue }
    }

    /// The purchasing entity for the draft order.
    public var purchasingEntity: GraphQLNullable<PurchasingEntityInput> {
      get { __data["purchasingEntity"] }
      set { __data["purchasingEntity"] = newValue }
    }

    /// The source channel that the order is attributed to. Set this to the handle of an order attribution definition configured for your sales channel app, such as `youtube` or `channel:amazon-us`.
    /// To set up order attribution for your app, follow the [order attribution guide](https://shopify.dev/docs/apps/build/sales-channels/order-attribution).
    public var sourceName: GraphQLNullable<String> {
      get { __data["sourceName"] }
      set { __data["sourceName"] = newValue }
    }

    /// Whether discount codes are allowed during checkout of this draft order.
    public var allowDiscountCodesInCheckout: GraphQLNullable<Bool> {
      get { __data["allowDiscountCodesInCheckout"] }
      set { __data["allowDiscountCodesInCheckout"] = newValue }
    }

    /// The purchase order number.
    public var poNumber: GraphQLNullable<String> {
      get { __data["poNumber"] }
      set { __data["poNumber"] = newValue }
    }

    /// The unique token identifying the draft order.
    public var sessionToken: GraphQLNullable<String> {
      get { __data["sessionToken"] }
      set { __data["sessionToken"] = newValue }
    }

    /// Fingerprint to guarantee bundles are handled correctly.
    public var transformerFingerprint: GraphQLNullable<String> {
      get { __data["transformerFingerprint"] }
      set { __data["transformerFingerprint"] = newValue }
    }
  }

}