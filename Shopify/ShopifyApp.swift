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
import AIAssistant

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

        // ── AI Assistant ─────────────────────────────────────────────
        // Real key lives in Secrets.swift which is gitignored.
        // Fill in Secrets.geminiAPIKey before running.
        AIAssistantKit.configure(with: AIAssistantConfig(
            geminiAPIKey:          Secrets.geminiAPIKey,
            shopifyHostname:       ShopifyConfig.hostname,
            storefrontAccessToken: ShopifyConfig.storefrontToken
        ))

        StripeAPI.defaultPublishableKey = ShopifyConfig.stripeTestKey
        StripeAPI.paymentRequest(
            withMerchantIdentifier: "merchant.com.team5.test",
            country: "EG",
            currency: "USD"
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
        }
    }
}
