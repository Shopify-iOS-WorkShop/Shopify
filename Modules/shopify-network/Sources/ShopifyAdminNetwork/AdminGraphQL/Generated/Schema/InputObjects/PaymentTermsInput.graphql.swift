// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension ShopifyAdminAPI {
  /// The input fields to create payment terms. Payment terms set the date that payment is due.
  struct PaymentTermsInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      paymentTermsTemplateId: GraphQLNullable<ID> = nil,
      paymentSchedules: GraphQLNullable<[PaymentScheduleInput]> = nil
    ) {
      __data = InputDict([
        "paymentTermsTemplateId": paymentTermsTemplateId,
        "paymentSchedules": paymentSchedules
      ])
    }

    /// Specifies the ID of the payment terms template.
    ///         Payment terms templates provide preset configurations to create common payment terms.
    ///         Refer to the
    ///         [PaymentTermsTemplate](https://shopify.dev/api/admin-graphql/latest/objects/paymenttermstemplate)
    ///         object for more details.
    public var paymentTermsTemplateId: GraphQLNullable<ID> {
      get { __data["paymentTermsTemplateId"] }
      set { __data["paymentTermsTemplateId"] = newValue }
    }

    /// Specifies the payment schedules for the payment terms.
    public var paymentSchedules: GraphQLNullable<[PaymentScheduleInput]> {
      get { __data["paymentSchedules"] }
      set { __data["paymentSchedules"] = newValue }
    }
  }

}