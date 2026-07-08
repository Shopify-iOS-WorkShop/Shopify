import DependencyInjection
import Swinject
import Common

// MARK: - Auth Assembly for Dependency Injection
public class AuthAssembly: DIAssembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        // Register Data Sources
        container.register(FirebaseAuthDataSource.self) { _ in
            FirebaseAuthDataSource()
        }
        
        container.register(GoogleSignInDataSource.self) { _ in
            GoogleSignInDataSource()
        }
        
        container.register(ShopifyCustomerDataSource.self) { _ in
            ShopifyCustomerDataSource()
        }
        
        container.register(ShopifyCustomerRESTDataSource.self) { _ in
            ShopifyCustomerRESTDataSource()
        }
        
        container.register(SessionLocalDataSource.self) { _ in
            SessionLocalDataSource()
        }
        
        // Register Repository
        container.register(AuthRepositoryProtocol.self) { resolver in
            AuthRepository(
                firebaseDataSource: resolver.resolve(FirebaseAuthDataSource.self)!,
                googleDataSource: resolver.resolve(GoogleSignInDataSource.self)!,
                shopifyRESTDataSource: resolver.resolve(ShopifyCustomerRESTDataSource.self)!,
                shopifyGraphQLDataSource: resolver.resolve(ShopifyCustomerDataSource.self)!,
                sessionLocalDataSource: resolver.resolve(SessionLocalDataSource.self)!,
                sessionStore: resolver.resolve(SessionProviding.self)!
            )
        }
        
        // Register Use Cases
        container.register(SignInUseCase.self) { resolver in
            SignInUseCase(repository: resolver.resolve(AuthRepositoryProtocol.self)!)
        }
        
        container.register(SignUpUseCase.self) { resolver in
            SignUpUseCase(repository: resolver.resolve(AuthRepositoryProtocol.self)!)
        }
        
        container.register(SignOutUseCase.self) { resolver in
            SignOutUseCase(repository: resolver.resolve(AuthRepositoryProtocol.self)!)
        }
        
        container.register(SignInWithSocialUseCase.self) { resolver in
            SignInWithSocialUseCase(repository: resolver.resolve(AuthRepositoryProtocol.self)!)
        }
        
        container.register(ContinueAsGuestUseCase.self) { _ in
            ContinueAsGuestUseCase()
        }
        
        container.register(RecoverPasswordUseCase.self) { resolver in
            RecoverPasswordUseCase(repository: resolver.resolve(AuthRepositoryProtocol.self)!)
        }
        
        container.register(SetPasswordForSocialUserUseCase.self) { resolver in
            SetPasswordForSocialUserUseCase(repository: resolver.resolve(AuthRepositoryProtocol.self)!)
        }
        
        container.register(RefreshCustomerTokenUseCase.self) { resolver in
            RefreshCustomerTokenUseCase(repository: resolver.resolve(AuthRepositoryProtocol.self)!)
        }
        
        container.register(ObserveSessionUseCase.self) { resolver in
            ObserveSessionUseCase(repository: resolver.resolve(AuthRepositoryProtocol.self)!)
        }
        
        // Register ViewModels
        container.register(LoginViewModel.self) { resolver in
            LoginViewModel(
                signInUseCase: resolver.resolve(SignInUseCase.self)!,
                signInWithSocialUseCase: resolver.resolve(SignInWithSocialUseCase.self)!
            )
        }
        
        container.register(RegistrationViewModel.self) { resolver in
            RegistrationViewModel(
                signUpUseCase: resolver.resolve(SignUpUseCase.self)!,
                signInWithSocialUseCase: resolver.resolve(SignInWithSocialUseCase.self)!,
                continueAsGuestUseCase: resolver.resolve(ContinueAsGuestUseCase.self)!
            )
        }
        
        container.register(ForgotPasswordViewModel.self) { resolver in
            ForgotPasswordViewModel(
                recoverPasswordUseCase: resolver.resolve(RecoverPasswordUseCase.self)!
            )
        }
    }
}
