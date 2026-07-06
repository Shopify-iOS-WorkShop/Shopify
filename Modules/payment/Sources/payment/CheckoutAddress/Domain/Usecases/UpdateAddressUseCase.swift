//
//  File.swift
//  
//
//  Created by Mazen Amr on 04/07/2026.
//

import Foundation

public protocol UpdateAddressUseCaseProtocol {
    func execute(address: Address) async throws
}

public struct UpdateAddressUseCase: UpdateAddressUseCaseProtocol {
    private let repository: AddressRepositoryProtocol
    
    public init(repository: AddressRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(address: Address) async throws {
        guard !address.mobileNumber.isEmpty else {
            throw NSError(domain: "Checkout", code: 400, userInfo: [NSLocalizedDescriptionKey: "Mobile number is required."])
        }
        
        try await repository.updateAddress(address)
    }
}
