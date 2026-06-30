import SwiftUI
import ProductDetails

@main
struct ShopifyApp: App {
    init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }

    var body: some Scene {
        WindowGroup {
            ProductDetailFactory.makeView(productId: 10390919708989)
        }
    }
}
