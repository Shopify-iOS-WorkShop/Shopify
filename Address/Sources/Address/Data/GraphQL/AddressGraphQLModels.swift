//
//  AddressGraphQLModels.swift
//  Address
//
//  Created by Mina Nashaat on 05/07/2026.
//

import Foundation


struct GraphQLEnvelope<T: Decodable>: Decodable {
    let data: T?
    let errors: [GraphQLTopLevelError]?
}

struct GraphQLTopLevelError: Decodable {
    let message: String
    let extensions: Extensions?

    struct Extensions: Decodable {
        let code: String?
    }
}


struct CustomerUserErrorDTO: Decodable {
    let code: String?
    let field: [String]?
    let message: String
}


struct MailingAddressDTO: Decodable {
    let id: String
    let firstName: String?
    let lastName: String?
    let address1: String?
    let address2: String?
    let city: String?
    let country: String?
    let countryCodeV2: String?
    let zip: String?
    let phone: String?
    let latitude: Double?
    let longitude: Double?
}

struct CustomerAddressCreateData: Decodable {
    let customerAddressCreate: CustomerAddressCreatePayload?
}

struct CustomerAddressCreatePayload: Decodable {
    let customerAddress: MailingAddressDTO?
    let customerUserErrors: [CustomerUserErrorDTO]
}

struct CustomerAddressUpdateData: Decodable {
    let customerAddressUpdate: CustomerAddressUpdatePayload?
}

struct CustomerAddressUpdatePayload: Decodable {
    let customerAddress: MailingAddressDTO?
    let customerUserErrors: [CustomerUserErrorDTO]
}



struct CustomerAddressDeleteData: Decodable {
    let customerAddressDelete: CustomerAddressDeletePayload?
}

struct CustomerAddressDeletePayload: Decodable {
    let deletedCustomerAddressId: String?
    let customerUserErrors: [CustomerUserErrorDTO]
}



struct GetCustomerAddressesData: Decodable {
    let customer: CustomerAddressesDTO?
}

struct CustomerAddressesDTO: Decodable {
    let defaultAddress: DefaultAddressIdDTO?
    let addresses: MailingAddressConnectionDTO
}

struct DefaultAddressIdDTO: Decodable {
    let id: String
}

struct MailingAddressConnectionDTO: Decodable {
    let edges: [MailingAddressEdgeDTO]
}

struct MailingAddressEdgeDTO: Decodable {
    let node: MailingAddressDTO
}


struct CustomerDefaultAddressUpdateData: Decodable {
    let customerDefaultAddressUpdate: CustomerDefaultAddressUpdatePayload?
}

struct CustomerDefaultAddressUpdatePayload: Decodable {
    let customerUserErrors: [CustomerUserErrorDTO]
}


extension MailingAddressDTO {
    func toDomain(isDefault: Bool) -> Address {
        let name = [firstName, lastName]
            .compactMap { $0 }
            .joined(separator: " ")
            .trimmingCharacters(in: .whitespaces)

        return Address(
            id: id,
            isDefault: isDefault,
            recipientName: name,
            mobileNumber: phone ?? "",
            street: address1 ?? "",
            apartment: address2 ?? "",
            city: city ?? "",
            country: country ?? "",
            countryCode: countryCodeV2 ?? "",
            postalCode: zip ?? "",
            latitude: latitude,
            longitude: longitude
        )
    }
}
