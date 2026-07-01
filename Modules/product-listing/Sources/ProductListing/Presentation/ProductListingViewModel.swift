//
//  File.swift
//  
//
//  Created by Mazen Amr on 29/06/2026.
//

import Foundation
@MainActor
public class ProductListingViewModel: ObservableObject {
    private var allProducts: [Product] = []
    
    @Published public var filteredProducts: [Product] = []
    @Published public var filterCriteria = FilterCriteria()
    @Published public var selectedFilter: String = "All"
    @Published public var selectedSortOption: SortOption = .none
    public var availableVendors: [String] {
        Array(Set(allProducts.map { $0.vendor })).sorted()
    }
    
    public var dynamicFilters: [String] {
        let types = Array(Set(allProducts.map { $0.productType.uppercased() }))
            .filter { !$0.isEmpty }
            .sorted()
        
        return ["All"] + types
    }
        public func applyFilters() {
            var results = allProducts.filter { product in
                var isMatch = true
                if let min = filterCriteria.minPrice, product.price < min { isMatch = false }
                if let max = filterCriteria.maxPrice, product.price > max { isMatch = false }
                if !filterCriteria.selectedVendors.isEmpty {
                    if !filterCriteria.selectedVendors.contains(product.vendor) { isMatch = false }
                }
                if filterCriteria.inStockOnly && !product.isInStock {
                    isMatch = false
                }
                
                return isMatch
            }
            
            if selectedFilter != "All" {
                results = results.filter { $0.productType.caseInsensitiveCompare(selectedFilter) == .orderedSame }
            }
        
        switch selectedSortOption {
            case .priceAsc:
                results.sort { $0.price < $1.price }
            case .priceDesc:
                results.sort { $0.price > $1.price }
            case .none:
                break
            }
            filteredProducts = results
        }
    
    public func clearFilters() {
        filterCriteria = FilterCriteria()
        applyFilters()
    }
    
    public let context: ListingContext
    private let repository: ProductListingRepositoryProtocol

    public init(context: ListingContext, repository: ProductListingRepositoryProtocol) {
        self.context = context
        self.repository = repository
    }

    public func fetchProducts() async {
        do {
            switch context {
            case .allProducts:
                allProducts = try await repository.fetchAllProducts()
            case .collection(let id, _):
                allProducts = try await repository.fetchProductsForCollection(id: id)
            }
            
            applyFilters()
        } catch {
            print("Network Error: \(error)")
        }
    }
}
