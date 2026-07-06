//
//  File.swift
//  
//
//  Created by Mazen Amr on 03/07/2026.
//

import Foundation

public protocol AddressRepositoryProtocol {
    func fetchSavedAddresses() async throws -> [Address]
    func updateAddress(_ address: Address) async throws
}
