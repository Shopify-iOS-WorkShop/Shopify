//
//  File.swift
//  
//
//  Created by Mazen Amr on 07/07/2026.
//

import Foundation

struct RESTOrderPayload: Encodable {
    let order: RESTOrderData
}

struct RESTOrderData: Encodable {
    let line_items: [RESTLineItem]
    let customer: RESTCustomer
    let billing_address: RESTAddress
    let shipping_address: RESTAddress
    let financial_status: String
    let shipping_lines: [RESTShippingLine]
    let discount_codes: [RESTDiscountCode]?
    let currency: String
    let presentment_currency: String  
    let send_receipt: Bool
}

struct RESTLineItem: Encodable {
    let variant_id: Int
    let quantity: Int
}

struct RESTCustomer: Encodable {
    let id: Int
}

struct RESTAddress: Encodable {
    let first_name: String
    let last_name: String
    let address1: String
    let city: String
    let country: String
    let phone: String
}

struct RESTShippingLine: Encodable {
    let title: String
    let price: String
}



struct RESTDiscountCode: Encodable {
    let code: String
    let amount: String
    let type: String
}
