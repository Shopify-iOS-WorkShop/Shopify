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
                let allProducts = try await fetchedProducts
                self.bestSellers = Array(
                    allProducts
                        .filter { $0.rating >= 4.5 }
                        .prefix(10)
                )
                self.brands = Array(try await fetchedBrands.prefix(8))
                self.categories = Array(try await fetchedCategories.prefix(4))
                
            } catch {
                self.errorMessage = error.localizedDescription
                print("Error fetching home data: \(error)")
            }
            isLoading = false
        }
}
