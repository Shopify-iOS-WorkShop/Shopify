import Foundation
import Combine

@MainActor
public class SearchViewModel: ObservableObject {
    @Published public var searchText: String = ""
    @Published public var predictiveProducts: [SearchProduct] = []
    @Published public var predictiveCollections: [SearchCollection] = []
    @Published public var isLoading: Bool = false
    @Published public var error: String? = nil
    @Published public var filter: SearchFilter = SearchFilter()
    @Published public var isFilterSheetPresented: Bool = false

    /// All unique vendor names from the current result set — used to populate the vendor picker.
    public var availableVendors: [String] {
        Array(Set(predictiveProducts.map(\.vendor))).sorted()
    }

    /// Products after applying the current filter.
    public var filteredProducts: [SearchProduct] {
        var result = predictiveProducts

        if filter.onlyAvailable {
            result = result.filter(\.availableForSale)
        }

        if let vendor = filter.vendor {
            result = result.filter { $0.vendor == vendor }
        }

        switch filter.sortBy {
        case .relevance:
            break
        case .priceLow:
            result = result.sorted {
                (Double($0.price) ?? 0) < (Double($1.price) ?? 0)
            }
        case .priceHigh:
            result = result.sorted {
                (Double($0.price) ?? 0) > (Double($1.price) ?? 0)
            }
        }

        return result
    }

    private let useCase: SearchUseCase
    private var searchTask: Task<Void, Never>?

    /// Designated init — used by DI (SearchFactory) and tests.
    public init(useCase: SearchUseCase) {
        self.useCase = useCase
    }

    /// Convenience init — used when no DI container is available (e.g. previews).
    public convenience init() {
        self.init(useCase: SearchUseCase(repository: SearchRepository()))
    }

    public func resetFilter() {
        filter = SearchFilter()
    }

    public func performPredictiveSearch(query: String) {
        searchTask?.cancel()
        
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.predictiveProducts = []
            self.predictiveCollections = []
            self.isLoading = false
            self.error = nil
            return
        }
        
        self.isLoading = true
        self.error = nil
        
        let useCase = self.useCase
        
        searchTask = Task { @MainActor in
            do {
                try await Task.sleep(nanoseconds: 300_000_000) 
        
                if Task.isCancelled { return }
                
                let result = try await useCase.executePredictiveSearch(query: query)
                
                if Task.isCancelled { return }
                
                self.predictiveProducts = result.products
                self.predictiveCollections = result.collections
                self.isLoading = false
            } catch {
                if Task.isCancelled { return }
                
                self.error = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
