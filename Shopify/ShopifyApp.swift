import SwiftUI
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
            Group {
                if #available(iOS 13.0.0, *) {
                    RegistrationView(
                        viewModel: RegistrationViewModel(
                            registerUseCase: RegisterUseCase(repository: AuthRepository()),
                            googleSignInUseCase: GoogleSignInUseCase(repository: AuthRepository()),
                            continueAsGuestUseCase: ContinueAsGuestUseCase()
                        ),
                        onNavigateToLogin: {
                            print("Navigate to login clicked")
                        }
                    )
                } else {
                    Text("Unsupported iOS version")
                }
            }
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
}
