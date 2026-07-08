//  SearchView.swift
//  search
//
//  Created by Al3dwy on 02/07/2026.
//
import SwiftUI

@MainActor
public struct SearchView: View {
    @StateObject private var viewModel: SearchViewModel
    @Environment(SearchCoordinator.self) private var coordinator

    public init(viewModel: SearchViewModel? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel ?? SearchViewModel())
    }

    public var body: some View {
        VStack(spacing: 0) {
            SearchHeaderView()
            HStack(spacing: 8) {
                SearchFieldView(text: $viewModel.searchText) { newValue in
                    viewModel.performPredictiveSearch(query: newValue)
                }

                if !viewModel.searchText.isEmpty {
                    filterButton
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.2), value: viewModel.searchText.isEmpty)
            .padding(.trailing, 16)

            content
        }
        .background(Color.pocketBackground.ignoresSafeArea())
        .navigationBarHidden(true)
        .sheet(isPresented: $viewModel.isFilterSheetPresented) {
            SearchFilterSheet(
                filter: $viewModel.filter,
                availableVendors: viewModel.availableVendors,
                onApply: { viewModel.isFilterSheetPresented = false },
                onReset: { viewModel.resetFilter() }
            )
            .presentationDetents([.medium, .large])
        }
    }

    // MARK: - Filter Button

    private var filterButton: some View {
        Button {
            viewModel.isFilterSheetPresented = true
        } label: {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(viewModel.filter.isActive ? .white : .pocketText)
                    .frame(width: 40, height: 40)
                    .background(viewModel.filter.isActive ? Color.pocketPink : Color.pocketChip)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(viewModel.filter.isActive ? Color.clear : Color.pocketBorder, lineWidth: 1)
                    }

                if viewModel.filter.isActive {
                    Circle()
                        .fill(Color.pocketTertiary)
                        .frame(width: 8, height: 8)
                        .offset(x: 3, y: -3)
                }
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading
            && viewModel.predictiveProducts.isEmpty
            && viewModel.predictiveCollections.isEmpty {
            Spacer()
            ProgressView("Searching...")
            Spacer()
        } else if viewModel.searchText.isEmpty {
            EmptySearchView()
        } else if viewModel.filteredProducts.isEmpty
            && viewModel.predictiveCollections.isEmpty
            && !viewModel.isLoading {
            NoResultsView {
                viewModel.searchText = ""
            }
        } else {
            if viewModel.filter.isActive {
                activeFilterChips
            }

            SearchResultsListView(
                collections: viewModel.predictiveCollections,
                products: viewModel.filteredProducts,           
                onProductTap: { product in
                    guard let productId = Int(
                        product.id.components(separatedBy: "/").last ?? ""
                    ) else { return }
                    coordinator.push(.productDetail(productId: productId))
                },
                onCollectionTap: { collection in
                    // Extract numeric ID from Shopify GID: "gid://shopify/Collection/123456789" → "123456789"
                    let numericId = collection.id.components(separatedBy: "/").last ?? collection.id
                    coordinator.push(.productListing(
                        collectionId: numericId,
                        title: collection.title
                    ))
                }
            )
        }
    }

    // MARK: - Active Filter Chips

    private var activeFilterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                if viewModel.filter.sortBy != .relevance {
                    filterChip(
                        label: viewModel.filter.sortBy.rawValue,
                        onRemove: { viewModel.filter.sortBy = .relevance }
                    )
                }
                if viewModel.filter.onlyAvailable {
                    filterChip(
                        label: "In Stock",
                        onRemove: { viewModel.filter.onlyAvailable = false }
                    )
                }
                if let vendor = viewModel.filter.vendor {
                    filterChip(
                        label: vendor,
                        onRemove: { viewModel.filter.vendor = nil }
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }

    private func filterChip(label: String, onRemove: @escaping () -> Void) -> some View {
        HStack(spacing: 4) {
            Text(label)
                .font(.caption.weight(.medium))
            Button { onRemove() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 9, weight: .bold))
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color.pocketPinkSoft)
        .foregroundColor(.pocketPink)
        .clipShape(Capsule())
    }
}

#Preview {
    SearchView()
}
