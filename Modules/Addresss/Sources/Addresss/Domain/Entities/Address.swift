//
//  Address.swift
//  Address
//
//  Created by Mina Nashaat on 05/07/2026.
//

import Foundation

public struct Address: Identifiable, Equatable, Hashable {

    public let id: String

    public var isDefault: Bool

    public var recipientName: String
    public var mobileNumber: String

    public var street: String
    public var apartment: String
    public var city: String
    public var country: String
    public var countryCode: String
    public var postalCode: String

    public var latitude: Double?
    public var longitude: Double?

    public init(
        id: String,
        isDefault: Bool = false,
        recipientName: String,
        mobileNumber: String,
        street: String,
        apartment: String = "",
        city: String,
        country: String,
        countryCode: String = "",
        postalCode: String,
        latitude: Double? = nil,
        longitude: Double? = nil
    ) {
        self.id = id
        self.isDefault = isDefault
        self.recipientName = recipientName
        self.mobileNumber = mobileNumber
        self.street = street
        self.apartment = apartment
        self.city = city
        self.country = country
        self.countryCode = countryCode
        self.postalCode = postalCode
        self.latitude = latitude
        self.longitude = longitude
    }

    public var title: String {
        isDefault ? "Default Address" : "Saved Address"
    }

    public var formattedDetails: String {
        var line = street
        if !apartment.isEmpty {
            line += ", \(apartment)"
        }
        return "\(line)\n\(city), \(country)"
    }

    public var oneLineAddress: String {
        [street, city, country].filter { !$0.isEmpty }.joined(separator: ", ")
    }
}

public struct AddressDraft: Equatable {
    public var id: String?
    public var recipientName: String = ""
    public var dialCode: String = "+1"
    public var mobileNumber: String = ""
    public var country: String = ""
    public var countryCode: String = ""
    public var city: String = ""
    public var street: String = ""
    public var apartment: String = ""
    public var postalCode: String = ""
    public var latitude: Double?
    public var longitude: Double?

    public init() {}

    public init(editing address: Address) {
        self.id = address.id
        self.recipientName = address.recipientName
        self.mobileNumber = address.mobileNumber
        self.country = address.country
        self.countryCode = address.countryCode
        self.city = address.city
        self.street = address.street
        self.apartment = address.apartment
        self.postalCode = address.postalCode
        self.latitude = address.latitude
        self.longitude = address.longitude
    }

    public var isEditing: Bool { id != nil }

    public var fullPhoneNumber: String {
        mobileNumber.isEmpty ? "" : "\(dialCode)\(mobileNumber)"
    }

    public var isValid: Bool {
        !recipientName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !mobileNumber.trimmingCharacters(in: .whitespaces).isEmpty &&
        !street.trimmingCharacters(in: .whitespaces).isEmpty &&
        !city.trimmingCharacters(in: .whitespaces).isEmpty &&
        !country.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
