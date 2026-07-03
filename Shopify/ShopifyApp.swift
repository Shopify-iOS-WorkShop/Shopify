import SwiftUI
import Home
import ShopifyNetwork
import ProductListing
import Auth
import Firebase
import GoogleSignIn
import Payment
@main
struct ShopifyApp: App {
    init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }

    var body: some Scene {
        WindowGroup {
            //ContentView()
            CheckoutAddressView()
        }
    }
}
