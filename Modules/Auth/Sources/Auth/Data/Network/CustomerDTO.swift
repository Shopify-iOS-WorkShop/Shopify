//
//  CustomerDTO.swift
//  Auth
//

import Foundation

struct CustomerResponse: Codable {
    let customer: CustomerDTO
}

struct CustomersSearchResponse: Codable {
    let customers: [CustomerDTO]
}

struct CustomerDTO: Codable {
    let id: Int
    let firstName: String?
    let lastName: String?
    let email: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
    }
}
