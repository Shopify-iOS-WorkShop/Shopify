
//  SwiftUIView.swift
//  search
//
//  Created by Al3dwy on 02/07/2026.
//
import SwiftUI

@MainActor
public struct SearchView: View {
    @StateObject private var viewModel: SearchViewModel

    public init(viewModel: SearchViewModel? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel ?? SearchViewModel())
    }

    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchHeaderView()
                SearchFieldView(text: $viewModel.searchText) { newValue in
                    viewModel.performPredictiveSearch(query: newValue)
                }
                content
            }
            .background(Color.pocketBackground.ignoresSafeArea())
            #if os(iOS)
            .navigationBarHidden(true)
            #endif
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.predictiveProducts.isEmpty && viewModel.predictiveCollections.isEmpty {
            Spacer()
            ProgressView("Searching...")
            Spacer()
        } else if viewModel.searchText.isEmpty {
            EmptySearchView()
        } else if viewModel.predictiveProducts.isEmpty && viewModel.predictiveCollections.isEmpty && !viewModel.isLoading {
            NoResultsView {
                viewModel.searchText = ""
            }
        } else {
            SearchResultsListView(
                collections: viewModel.predictiveCollections,
                products: viewModel.predictiveProducts
            )
        }
    }
}

#Preview {
    SearchView()
}
