//
//  File.swift
//  
//
//  Created by Mazen Amr on 28/06/2026.
//

import Foundation
import SwiftUI

@MainActor
public class HomeViewModel: ObservableObject {
    @Published public var bestSellers: [Product] = []
    @Published public var brands: [Brand] = []
    @Published public var categories: [Category] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    
    private let repository: HomeRepositoryProtocol
    
    public init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }
    
    public func loadData() async {
        isLoading = true
        do {
            async let fetchedProducts = repository.fetchBestSellers()
            async let fetchedBrands = repository.fetchBrands()
            async let fetchedCategories = repository.fetchCategories()
        
            self.bestSellers = try await fetchedProducts
            self.brands = try await fetchedBrands
            self.categories = try await fetchedCategories
            
        } catch {
            self.errorMessage = error.localizedDescription
            print("Error fetching home data: \(error)")
        }
        isLoading = false
    }
}
