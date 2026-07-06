//
//  AddressGraphQLOperations.swift
//  Address
//
//  Created by Mina Nashaat on 05/07/2026.
//

import Foundation

enum AddressGraphQLOperations {

    static let createAddress = """
    mutation AddCustomerAddress($customerAccessToken: String!, $address: MailingAddressInput!) {
      customerAddressCreate(customerAccessToken: $customerAccessToken, address: $address) {
        customerAddress {
          id
          firstName
          lastName
          address1
          address2
          city
          country
          zip
          phone
        }
        customerUserErrors { code field message }
      }
    }
    """

    static let updateAddress = """
    mutation UpdateCustomerAddress($customerAccessToken: String!, $id: ID!, $address: MailingAddressInput!) {
      customerAddressUpdate(customerAccessToken: $customerAccessToken, id: $id, address: $address) {
        customerAddress {
          id
          firstName
          lastName
          address1
          address2
          city
          country
          zip
          phone
        }
        customerUserErrors { code field message }
      }
    }
    """
    
    static let deleteAddress = """
    mutation DeleteCustomerAddress($customerAccessToken: String!, $id: ID!) {
      customerAddressDelete(customerAccessToken: $customerAccessToken, id: $id) {
        deletedCustomerAddressId
        customerUserErrors { code field message }
      }
    }
    """

    static let fetchAddresses = """
    query GetCustomerAddresses($customerAccessToken: String!) {
      customer(customerAccessToken: $customerAccessToken) {
        defaultAddress { id }
        addresses(first: 50) {
          edges {
            node {
              id
              firstName
              lastName
              address1
              address2
              city
              country
              countryCodeV2
              zip
              phone
              latitude
              longitude
            }
          }
        }
      }
    }
    """

    static let setDefaultAddress = """
    mutation UpdateCustomerDefaultAddress($customerAccessToken: String!, $addressId: ID!) {
      customerDefaultAddressUpdate(customerAccessToken: $customerAccessToken, addressId: $addressId) {
        customer { id defaultAddress { id } }
        customerUserErrors { code field message }
      }
    }
    """
}
