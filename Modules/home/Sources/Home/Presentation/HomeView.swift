import SwiftUI
import Common
import UIKit

public struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Environment(HomeCoordinator.self) private var coordinator
    /// Shared currency store injected via .environment() in ContentView.
    /// HomeView observes it directly — any currency change causes a re-render,
    /// updating product prices across the entire home screen instantly.
    @Environment(CurrencyStore.self) private var currencyStore

    public var favoritedIDs: Set<String>
    public var onFavoriteTap: ((Product) -> Void)?

    public init(
        viewModel: HomeViewModel,
        favoritedIDs: Set<String> = [],
        onFavoriteTap: ((Product) -> Void)? = nil
    ) {
        self.viewModel = viewModel
        self.favoritedIDs = favoritedIDs
        self.onFavoriteTap = onFavoriteTap
    }

    public var body: some View {
        ZStack(alignment: .top) {
            DS.background.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    AdsCarouselView(ads: viewModel.ads) { ad in
                        handleAdTap(ad)
                    }
                    .padding(.horizontal, 16)

                    SectionHeaderView(title: "Shop by Brand", hasViewAll: true) {
                        coordinator.push(.catalog(type: .brands))
                    }
                    if viewModel.isLoading && viewModel.brands.isEmpty {
                        BrandsPlaceholderView()
                    } else {
                        BrandsScrollView(brands: viewModel.brands)
                    }

                    SectionHeaderView(title: "Main Categories", hasViewAll: true) {
                        coordinator.push(.catalog(type: .categories))
                    }
                    
                    if viewModel.isLoading && viewModel.categories.isEmpty {
                        CategoriesPlaceholderView()
                    } else {
                        CategoriesGridView(categories: viewModel.categories)
                            .padding(.horizontal, 16)
                    }

                    SectionHeaderView(title: "Best Sellers", hasViewAll: true) {
                        coordinator.push(.productListing(collectionId: nil, title: "All Products"))
                    }

                    if viewModel.isLoading {
                        ProgressView("Loading products...")
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        BestSellersGridView(
                            products: viewModel.bestSellers,
                            favoritedIDs: favoritedIDs,
                            onFavoriteTap: onFavoriteTap
                        )
                        .padding(.horizontal, 16)
                    }

                    Spacer(minLength: 24)
                }
                .padding(.top, 8)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("PocketShop")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(DS.textPri)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    coordinator.onCartTapped?()
                }) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "cart")
                            .foregroundColor(DS.textPri)
                            .font(.system(size: 18, weight: .medium))
                        
                        if coordinator.cartBadgeCount > 0 {
                            Text("\(coordinator.cartBadgeCount)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .frame(minWidth: 16, minHeight: 16)
                                .background(DS.red)
                                .clipShape(Circle())
                                .offset(x: 10, y: -8)
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.loadData()
            }
        }
    }

    private func handleAdTap(_ ad: Ad) {
        switch ad.destination {
        case .product(let id):
            guard let productId = Int(id) else { return }
            coordinator.push(.productDetail(productId: productId))
        case .collection(let id, let title):
            coordinator.push(.productListing(collectionId: id, title: title))
        case .url(let url):
            UIApplication.shared.open(url)
        }
    }
}

struct BrandsPlaceholderView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(0..<5, id: \.self) { _ in
                    VStack(spacing: 6) {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 62, height: 62)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 50, height: 10)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct CategoriesPlaceholderView: View {
    let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(0..<4, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 90)
            }
        }
        .padding(.horizontal, 16)
    }
}
