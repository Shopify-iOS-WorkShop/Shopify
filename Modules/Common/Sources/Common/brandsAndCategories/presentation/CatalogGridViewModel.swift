//
//  presentation.swift
//  Common
//
//  Created by Mina on 01/07/2026.
//

import SwiftUI

public enum CatalogDisplayType {
    case brands
    case categories
    
    var navigationTitle: String {
        switch self {
        case .brands: return "Brands"
        case .categories: return "Categories"
        }
    }
}

@MainActor
public class CatalogGridViewModel: ObservableObject {
    @Published public var items: [GridItemEntity] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil
    
    private let useCase: FetchCollectionsUseCaseProtocol
    private let type: CatalogDisplayType
    
    public init(type: CatalogDisplayType, useCase: FetchCollectionsUseCaseProtocol = FetchCollectionsUseCase()) {
        self.type = type
        self.useCase = useCase
    }
    
    public func loadCatalogData() async {
        isLoading = true
        errorMessage = nil
        do {
            let (brands, categories) = try await useCase.execute()
            switch type {
            case .brands:
                self.items = brands
            case .categories:
                self.items = categories
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
