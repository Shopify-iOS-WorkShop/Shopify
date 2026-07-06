//
//  File.swift
//  
//
//  Created by Mazen Amr on 03/07/2026.
//

import Foundation
public protocol GetSavedAddressesUseCaseProtocol {
    func execute() async throws -> [Address]
}

public struct GetSavedAddressesUseCase: GetSavedAddressesUseCaseProtocol {
    private let repository: AddressRepositoryProtocol
    
    public init(repository: AddressRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute() async throws -> [Address] {
        return try await repository.fetchSavedAddresses()
    }
}
