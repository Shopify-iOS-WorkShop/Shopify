import Foundation
import SwiftUI

public struct ProductListingView: View {
    public let title: String
    @ObservedObject public var viewModel: ProductListingViewModel
    @State private var selectedFilter: String = "All"
    @State private var showingFilterDrawer = false
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    public init(title: String, viewModel: ProductListingViewModel) {
        self.title = title
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(viewModel.dynamicFilters, id: \.self) { filter in
                        Button(action: {
                            selectedFilter = filter
                            viewModel.selectedFilter = filter 
                            viewModel.applyFilters()
                        }) {
                            Text(filter)
                                .font(.system(size: 13, weight: .medium))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedFilter == filter ? DS.navy : DS.background)
                                .foregroundColor(selectedFilter == filter ? .white : DS.textPri)
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            
            HStack {
                Text("Sort by:")
                    .font(.system(size: 13))
                    .foregroundColor(DS.textSec)

                Menu {
                    Button("None") {
                        viewModel.selectedSortOption = .none
                        viewModel.applyFilters()
                    }
                    Button("Price: Low to High") {
                        viewModel.selectedSortOption = .priceAsc
                        viewModel.applyFilters()
                    }
                    Button("Price: High to Low") {
                        viewModel.selectedSortOption = .priceDesc
                        viewModel.applyFilters()
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(viewModel.selectedSortOption == .none ? "None" : viewModel.selectedSortOption.rawValue)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(DS.textPri)
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(DS.textPri)
                    }
                }
                
                Spacer()

                Text("\(viewModel.filteredProducts.count) results")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(DS.textSec)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.filteredProducts) { product in
                        ProductCardView(product: product)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
        }
        .task {
            await viewModel.fetchProducts()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingFilterDrawer = true
                }) {
                    Image(systemName: "line.3.horizontal.decrease")
                        .foregroundColor(DS.textPri)
                }
            }
        }
        .sheet(isPresented: $showingFilterDrawer) {
            FilterDrawerSheet(viewModel: viewModel)
                .presentationDetents([.medium, .large])
        }
    }
}
