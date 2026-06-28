import SwiftUI

public struct HomeView: View {
@StateObject private var viewModel: HomeViewModel

    public init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                DS.background.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        FlashSaleBannerView()
                            .padding(.horizontal, 16)

                        SectionHeaderView(title: "Shop by Brand", hasViewAll: true)
                        BrandsScrollView(brands: viewModel.brands)

                        SectionHeaderView(title: "Main Categories", hasViewAll: false)
                        CategoriesGridView(categories: viewModel.categories)

                        SectionHeaderView(title: "Best Sellers", hasViewAll: true)
                        
                        if viewModel.isLoading {
                            ProgressView("Loading products...")
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            BestSellersGridView(products: viewModel.bestSellers)
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
                    Button(action: {}) {
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
                    Button(action: {}) {
                        Image(systemName: "cart")
                            .foregroundColor(DS.textPri)
                            .font(.system(size: 18, weight: .medium))
                    }
                }
            }.task {
                await viewModel.loadData()
            }
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
