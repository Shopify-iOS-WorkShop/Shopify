import SwiftUI
import Common
import UIKit

public struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Environment(HomeCoordinator.self) private var coordinator

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
                    BrandsScrollView(brands: viewModel.brands)

                    SectionHeaderView(title: "Main Categories", hasViewAll: true) {
                        coordinator.push(.catalog(type: .categories))
                    }
                    CategoriesGridView(categories: viewModel.categories)

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
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    coordinator.onMenuTapped?()
                }) {
                    Image(systemName: "line.3.horizontal")
                        .foregroundColor(DS.textPri)
                        .font(.system(size: 18, weight: .medium))
                }
            }
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
                                .background(Color.pink)
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
