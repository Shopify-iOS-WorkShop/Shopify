import SwiftUI
import SwiftData
import Home
import ShopifyNetwork
import ProductListing
import Auth
import Firebase
import GoogleSignIn

@main
struct ShopifyApp: App {
    
    // SwiftData ModelContainer - shared across the app
    let modelContainer: ModelContainer
    
    init() {
        // Configure Firebase
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        // Set up SwiftData
        do {
            // TODO: Add all @Model types from modules here when they are created
            // For now, create an empty container
            let schema = Schema([])
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
