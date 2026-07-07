//
//  File.swift
//  
//
//  Created by Mazen Amr on 07/07/2026.
//

import Foundation

public struct CheckoutAddress {
    public let address1: String
    public let city: String
    public let country: String
    public let firstName: String
    public let lastName: String
    public let phone: String
 
    public init(address1: String, city: String, country: String, firstName: String, lastName: String, phone: String) {
        self.address1 = address1
        self.city = city
        self.country = country
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
    }
}
