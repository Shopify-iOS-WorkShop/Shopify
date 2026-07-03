import Foundation
import Combine

@MainActor
public class SearchViewModel: ObservableObject {
    @Published public var searchText: String = ""
    @Published public var predictiveProducts: [SearchProduct] = []
    @Published public var predictiveCollections: [SearchCollection] = []
    @Published public var isLoading: Bool = false
    @Published public var error: String? = nil
    
    private let useCase: SearchUseCase
    private var searchTask: Task<Void, Never>?
    
    public init(useCase: SearchUseCase = SearchUseCase(repository: SearchRepository())) {
        self.useCase = useCase
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
