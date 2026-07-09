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
    @Published public var ads: [Ad] = [Ad.fallback]
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?

    /// Tracks whether the initial fetch has already completed so returning to
    /// Home (from a pushed screen or a tab switch) doesn't refetch and flash
    /// the loading state again. Callers that truly need fresh data (e.g. a
    /// future pull-to-refresh) can pass `force: true`.
    private var hasLoadedOnce: Bool = false

    private let repository: HomeRepositoryProtocol
    
    public init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }
    
    public func loadData(force: Bool = false) async {
        guard !isLoading else { return }  // Only prevent if already loading
        guard force || !hasLoadedOnce else { return }
        isLoading = true
        
        // MARK: - Simulator Network Bug Workaround
        // Delay fetching slightly to allow the iOS Simulator network stack to fully
        // initialize. Instantaneous QUIC/HTTP3 requests on launch often hang for 60s.
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        errorMessage = nil

        var messages: [String] = []

        do {
            let allProducts = try await repository.fetchBestSellers()
            bestSellers = Array(
                allProducts
                    .filter { $0.rating >= 4.5 }
                    .prefix(10)
            )
        } catch {
            messages.append("Products: \(error.localizedDescription)")
            print("Error fetching home products: \(error)")
        }

        do {
            brands = Array(try await repository.fetchBrands().prefix(8))
        } catch {
            messages.append("Brands: \(error.localizedDescription)")
            print("Error fetching home brands: \(error)")
        }

        do {
            let allCategories = try await repository.fetchCategories()
            categories = Array(
                allCategories
                    .filter { $0.title != "Home page" && $0.title != "Hydrogen" }
                    .prefix(4)
            )
        } catch {
            messages.append("Categories: \(error.localizedDescription)")
            print("Error fetching home categories: \(error)")
        }

        do {
            let fetchedAds = try await repository.fetchAds()
            // Never leave the carousel empty — fall back to a static promo
            // so the Home screen always has something to show.
            ads = fetchedAds.isEmpty ? [Ad.fallback] : fetchedAds
        } catch {
            messages.append("Ads: \(error.localizedDescription)")
            print("Error fetching home ads: \(error)")
            ads = [Ad.fallback]
        }

        errorMessage = messages.isEmpty ? nil : messages.joined(separator: "\n")
        hasLoadedOnce = true
        isLoading = false
    }
}
