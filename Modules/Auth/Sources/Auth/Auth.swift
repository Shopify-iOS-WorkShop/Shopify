// The Swift Programming Language
// https://docs.swift.org/swift-book
	
 public typealias AuthUserEntity = AuthUser

@_exported import protocol Auth.AuthRepositoryInterface
public enum AuthRepositoryFactory {
    public static func make() -> AuthRepositoryInterface {
        AuthRepository()
    }
}

// MARK: - Presentation Exports
@available(iOS 13.0.0, *)
public typealias AppRegistrationView = RegistrationView

@available(iOS 13.0.0, *)
public typealias AppRegistrationViewModel = RegistrationViewModel
