//
//  File.swift
//  
//
//  Created by Mazen Amr on 29/06/2026.
//
import Foundation
import SwiftUI

@MainActor
public class ProductListingViewModel: ObservableObject {
    private var allProducts: [Product] = []
    
    @Published public var filteredProducts: [Product] = []
    @Published public var filterCriteria = FilterCriteria()
    @Published public var selectedFilter: String = "All"
    @Published public var selectedSortOption: SortOption = .none
    @Published public var availableVendors: [String] = []
    @Published public var dynamicFilters: [String] = ["All"]
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    
    public let context: ListingContext
    private let repository: ProductListingRepositoryProtocol
    private let filterUseCase: FilterProductsUseCase
    
    public init(
        context: ListingContext,
        repository: ProductListingRepositoryProtocol,
        filterUseCase: FilterProductsUseCase = FilterProductsUseCase()
    ) {
        self.context = context
        self.repository = repository
        self.filterUseCase = filterUseCase
    }
    
    public func applyFilters() {
        filteredProducts = filterUseCase.execute(
            products: allProducts,
            criteria: filterCriteria,
            selectedCategory: selectedFilter,
            sortOption: selectedSortOption
        )
    }
    
    public func clearFilters() {
        filterCriteria = FilterCriteria()
        selectedFilter = "All"
        selectedSortOption = .none
        applyFilters()
    }
    
    public func fetchProducts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            switch context {
            case .allProducts:
                allProducts = try await repository.fetchAllProducts()
            case .collection(let id, _):
                allProducts = try await repository.fetchProductsForCollection(id: id)
            }
            setupFilterOptions(from: allProducts)
            applyFilters()
            
        } catch {
            errorMessage = error.localizedDescription 
            print("Network Error: \(error)")
        }
        
        isLoading = false
    }
    
    private func setupFilterOptions(from products: [Product]) {
        availableVendors = Array(Set(products.map { $0.vendor })).sorted()
        
        let types = Array(Set(products.map { $0.productType.uppercased() }))
            .filter { !$0.isEmpty }
            .sorted()
        
        dynamicFilters = ["All"] + types
    }
}
