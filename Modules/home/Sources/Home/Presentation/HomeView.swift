import SwiftUI

public struct MockData {
    public static let brands = [
        Brand(id: "1", title: "Luxe",  iconName: "sparkles"),
        Brand(id: "2", title: "Vogue", iconName: "eyeglasses"),
        Brand(id: "3", title: "Terra", iconName: "leaf"),
        Brand(id: "4", title: "Aqua",  iconName: "drop"),
        Brand(id: "5", title: "Orbit", iconName: "globe")
    ]

    public static let categories = [
        Category(id: "c1", title: "Man",         iconName: "figure.stand"),
        Category(id: "c2", title: "Women",        iconName: "figure.dress"),
        Category(id: "c3", title: "Kids",         iconName: "figure.and.child.holdinghands"),
        Category(id: "c4", title: "Accessories",  iconName: "watch.analog")
    ]

    public static let bestSellers = [
        Product(id: "p1", title: "Premium Leather Tote", vendor: "BOUTIQUE",  price: 49.99, rating: 4.5, imageURL: nil),
        Product(id: "p2", title: "Urban White Sneakers", vendor: "ESSENTIAL", price: 89.00, rating: 4.8, imageURL: nil)
    ]
}

public struct HomeView: View {
    public init() {}

    public var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                DS.background.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {

                        FlashSaleBannerView()
                            .padding(.horizontal, 16)

                        SectionHeaderView(title: "Shop by Brand", hasViewAll: true)
                        BrandsScrollView(brands: MockData.brands)

                        SectionHeaderView(title: "Main Categories", hasViewAll: false)
                        CategoriesGridView(categories: MockData.categories)
                            .padding(.horizontal, 16)

                        SectionHeaderView(title: "Best Sellers", hasViewAll: true)
                        BestSellersGridView(products: MockData.bestSellers)
                            .padding(.horizontal, 16)

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
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
