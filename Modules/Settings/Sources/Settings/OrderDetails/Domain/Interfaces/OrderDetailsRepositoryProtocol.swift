//
//  File.swift
//  
//
//  Created by Mazen Amr on 07/07/2026.
//

import Foundation

public protocol OrderDetailsRepositoryProtocol {
    func fetchOrderDetails(orderId: String, customerAccessToken: String) async throws -> FullOrder
}
