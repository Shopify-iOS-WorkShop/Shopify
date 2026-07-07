//
//  AddressUseCases.swift
//  Address
//
//  Created by Mina Nashaat on 05/07/2026.
//

import Foundation

public struct FetchSavedAddressesUseCase {
    private let repository: AddressRepositoryProtocol
    public init(repository: AddressRepositoryProtocol) {
        self.repository = repository
    }
    public func execute() async throws -> [Address] {
        try await repository.fetchSavedAddresses()
    }
}

public struct AddAddressUseCase {
    private let repository: AddressRepositoryProtocol
    public init(repository: AddressRepositoryProtocol) {
        self.repository = repository
    }
    public func execute(_ draft: AddressDraft) async throws -> Address {
        try await repository.addAddress(draft)
    }
}

public struct UpdateAddressUseCase {
    private let repository: AddressRepositoryProtocol
    public init(repository: AddressRepositoryProtocol) {
        self.repository = repository
    }
    public func execute(_ draft: AddressDraft) async throws -> Address {
        try await repository.updateAddress(draft)
    }
}

public struct DeleteAddressUseCase {
    private let repository: AddressRepositoryProtocol
    public init(repository: AddressRepositoryProtocol) {
        self.repository = repository
    }
    public func execute(id: String) async throws {
        try await repository.deleteAddress(id: id)
    }
}

public struct SetDefaultAddressUseCase {
    private let repository: AddressRepositoryProtocol
    public init(repository: AddressRepositoryProtocol) {
        self.repository = repository
    }
    public func execute(id: String) async throws {
        try await repository.setDefaultAddress(id: id)
    }
}
