//
//  File.swift
//  
//
//  Created by Mazen Amr on 01/07/2026.
//

import Foundation

public struct FilterProductsUseCase {
    
    public init() {}
    
    public func execute(
        products: [Product],
        criteria: FilterCriteria,
        selectedCategory: String,
        sortOption: SortOption
    ) -> [Product] {
        var results = products.filter { product in
            if let min = criteria.minPrice, product.price < min { return false }
            if let max = criteria.maxPrice, product.price > max { return false }
            if !criteria.selectedVendors.isEmpty, !criteria.selectedVendors.contains(product.vendor) { return false }
            if criteria.inStockOnly, !product.isInStock { return false }
            
            return true
        }
        
        if selectedCategory != "All" {
            results = results.filter { $0.productType.caseInsensitiveCompare(selectedCategory) == .orderedSame }
        }
        
        switch sortOption {
        case .priceAsc:
            results.sort { $0.price < $1.price }
        case .priceDesc:
            results.sort { $0.price > $1.price }
        case .none:
            break
        }
        
        return results
    }
}
