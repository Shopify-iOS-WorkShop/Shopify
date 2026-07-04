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
    /// Derives promotional "ads" from real store data (products currently
    /// discounted in the SALE collection). Returns an empty array — never
    /// throws to the UI layer's benefit — when there is nothing to promote.
    func fetchAds() async throws -> [Ad]
}
