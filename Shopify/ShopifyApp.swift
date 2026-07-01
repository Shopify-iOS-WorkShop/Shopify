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
            
            let homeRepo = HomeRepository(networkClient: client)
            let homeViewModel = HomeViewModel(repository: homeRepo)
            let listingRepo = ProductListingRepository(networkClient: client)
            //let testContext = ListingContext.collection(id: "550537363773", title: "ADIDAS")
            let testContext = ListingContext.allProducts
            
            let listingViewModel = ProductListingViewModel(context: testContext, repository: listingRepo)
            
            NavigationStack {
                ProductListingView(title: "Women's Tops", viewModel: listingViewModel)
            }
        }
    }
}
