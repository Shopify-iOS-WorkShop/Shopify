import Foundation
import SwiftUI

public struct ProductListingView: View {
    public let title: String
    @StateObject public var viewModel: ProductListingViewModel
    @State private var selectedFilter: String = "All"
    @State private var showingFilterDrawer = false
    
    @Environment(ProductListingCoordinator.self) private var coordinator
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    public init(title: String, viewModel: @autoclosure @escaping () -> ProductListingViewModel) {
        self.title = title
        self._viewModel = StateObject(wrappedValue: viewModel())
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
                                .background(selectedFilter == filter ? DS.primary : DS.chipBG)
                                .foregroundColor(selectedFilter == filter ? .white : DS.textPri)
                                .clipShape(Capsule())
                                .overlay {
                                    Capsule()
                                        .stroke(selectedFilter == filter ? Color.clear : DS.border, lineWidth: 1)
                                }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(DS.background)
            
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
            .background(DS.background)
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.filteredProducts) { product in
                        Button(action: {
                            coordinator.push(.productDetail(productId: Int(product.id) ?? 0))
                        }) {
                            ProductCardView(product: product)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.filteredProducts.map { $0.id })
        .background(DS.background.ignoresSafeArea())
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
