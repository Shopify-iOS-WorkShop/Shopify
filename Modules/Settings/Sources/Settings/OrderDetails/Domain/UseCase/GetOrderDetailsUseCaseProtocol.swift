//
//  File.swift
//  
//
//  Created by Mazen Amr on 07/07/2026.
//

import Foundation

public protocol GetOrderDetailsUseCaseProtocol {
    func execute(orderId: String, customerAccessToken: String) async throws -> FullOrder
}

public struct GetOrderDetailsUseCase: GetOrderDetailsUseCaseProtocol {
    private let repository: OrderDetailsRepositoryProtocol
    
    public init(repository: OrderDetailsRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(orderId: String, customerAccessToken: String) async throws -> FullOrder {
        return try await repository.fetchOrderDetails(orderId: orderId, customerAccessToken: customerAccessToken)
    }
}
