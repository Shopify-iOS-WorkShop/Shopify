// The Swift Programming Language
// https://docs.swift.org/swift-book

import DependencyInjection
	
public typealias AuthUserEntity = AuthUser

@available(iOS 13.0.0, *)
public enum AuthRepositoryFactory {
    public static func make() -> AuthRepositoryProtocol {
        guard let repository = DIContainer.shared.resolve(AuthRepositoryProtocol.self) else {
            fatalError("AuthRepositoryProtocol is not registered. Call AppAssembly.setup before creating auth views.")
        }
        return repository
    }
}

// MARK: - Dependency Injection Assembly Export
public typealias AppAuthAssembly = AuthAssembly

// MARK: - Presentation Exports
@available(iOS 13.0.0, *)
public typealias AppRegistrationView = RegistrationView

@available(iOS 13.0.0, *)
public typealias AppRegistrationViewModel = RegistrationViewModel

@available(iOS 13.0.0, *)
public typealias AppForgotPasswordView = ForgotPasswordView

@available(iOS 13.0.0, *)
public typealias AppForgotPasswordViewModel = ForgotPasswordViewModel

@available(iOS 13.0.0, *)
public typealias AppSetPasswordView = SetPasswordView

@available(iOS 13.0.0, *)
public typealias AppSetPasswordViewModel = SetPasswordViewModel
