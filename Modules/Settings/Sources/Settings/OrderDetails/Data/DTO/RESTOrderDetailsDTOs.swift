//
//  File.swift
//  
//
//  Created by Mazen Amr on 07/07/2026.
//

import Foundation
struct RESTOrderResponse: Decodable { let order: RESTOrder }

struct RESTOrder: Decodable {
    let id: Int
    let order_number: Int
    let processed_at: String
    let financial_status: String?
    let total_price: String
    let subtotal_price: String
    let currency: String
    let shipping_address: RESTAddress?
    let line_items: [RESTLineItem]
    let shipping_lines: [RESTShippingLine]?
}

struct RESTAddress: Decodable {
    let first_name: String?
    let last_name: String?
    let address1: String?
    let city: String?
    let country: String?
    let phone: String?
}

struct RESTLineItem: Decodable {
    let id: Int
    let title: String
    let variant_title: String?
    let quantity: Int
    let price: String
}

struct RESTShippingLine: Decodable { let price: String }
