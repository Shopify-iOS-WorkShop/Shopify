import SwiftUI
import SwiftData
import Home
import ShopifyNetwork
import ProductListing
import Auth
import Cart
import Firebase
import GoogleSignIn
import Payment
import Favorites
import StripeCore

@main
struct ShopifyApp: App {
    
    let modelContainer: ModelContainer
    
    init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        do {
            let schema = Schema([
                FavoriteItem.self,
                CartRecord.self
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
        
        _ = AppAssembly.shared.setup(with: modelContainer.mainContext)
        
        StripeAPI.defaultPublishableKey = ShopifyConfig.stripeTestKey
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
        }
    }
}
