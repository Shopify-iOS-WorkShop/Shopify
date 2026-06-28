//
//  File.swift
//  
//
//  Created by Mazen Amr on 27/06/2026.
//

import Foundation
import ShopifyNetwork

public protocol HomeRepositoryProtocol {
    func fetchBestSellers() async throws -> [Product]
    func fetchBrands() async throws -> [Brand]
    func fetchCategories() async throws -> [Category]
}
