//
//  AddressRepositoryProtocol.swift
//  Address
//
//  Created by Mina Nashaat on 05/07/2026.
//

import Foundation

public protocol AddressRepositoryProtocol {
    func fetchSavedAddresses() async throws -> [Address]

    func addAddress(_ draft: AddressDraft) async throws -> Address

    func updateAddress(_ draft: AddressDraft) async throws -> Address

    func deleteAddress(id: String) async throws

    func setDefaultAddress(id: String) async throws
}
