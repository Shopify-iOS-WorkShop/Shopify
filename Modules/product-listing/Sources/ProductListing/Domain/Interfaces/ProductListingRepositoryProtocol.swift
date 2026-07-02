//
//  File.swift
//  
//
//  Created by Mazen Amr on 30/06/2026.
//

import Foundation

public protocol ProductListingRepositoryProtocol {
    func fetchAllProducts() async throws -> [Product]
    func fetchProductsForCollection(id: String) async throws -> [Product]
}
