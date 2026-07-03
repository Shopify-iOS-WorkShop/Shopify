//
//  File.swift
//  
//
//  Created by Mazen Amr on 29/06/2026.
//

import Foundation

public struct FilterCriteria {
    var minPrice: Double?
    var maxPrice: Double?
    var inStockOnly: Bool = false
    var selectedVendors: Set<String> = []
}
