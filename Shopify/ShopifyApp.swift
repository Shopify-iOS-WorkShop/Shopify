import SwiftUI
import Home
import ShopifyNetwork
import ProductListing
import Auth
import Firebase
import GoogleSignIn
@main
struct ShopifyApp: App {
    init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }

    var body: some Scene {
        WindowGroup {
            let client = URLSessionNetworkClient()
            let repo = HomeRepository(networkClient: client)
            let viewModel = HomeViewModel(repository: repo)
            NavigationStack {
                ProductListingView(title: "Women's Tops")
            }
        }
    }
}
