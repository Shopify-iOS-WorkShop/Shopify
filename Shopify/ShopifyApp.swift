import SwiftUI
import SwiftData
import Home
import ShopifyNetwork
import ProductListing
import Auth
import Cart
import Firebase
import GoogleSignIn

@main
struct ShopifyApp: App {
    
    // SwiftData ModelContainer - shared across the app
    let modelContainer: ModelContainer
    
    init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        do {
            // Register all @Model types from modules
            let schema = Schema([
                CartRecord.self  // Cart module SwiftData model
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
        
        // Initialize DI with ModelContext
        _ = AppAssembly.shared.setup(with: modelContainer.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
        }
    }
}
