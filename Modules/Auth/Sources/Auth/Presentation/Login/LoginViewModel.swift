import Foundation
import Combine

public final class LoginViewModel: ObservableObject {
    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil
    @Published public private(set) var completedSession: Session? = nil
    @Published public private(set) var pendingSocialUser: SocialSignInResult? = nil

    private let signInUseCase: SignInUseCaseProtocol
    private let signInWithSocialUseCase: SignInWithSocialUseCaseProtocol

    public init(
        signInUseCase: SignInUseCaseProtocol,
        signInWithSocialUseCase: SignInWithSocialUseCaseProtocol
    ) {
        self.signInUseCase            = signInUseCase
        self.signInWithSocialUseCase  = signInWithSocialUseCase
    }

    public convenience init(repository: AuthRepositoryProtocol = AuthRepositoryFactory.make()) {
        self.init(
            signInUseCase: SignInUseCase(repository: repository),
            signInWithSocialUseCase: SignInWithSocialUseCase(repository: repository)
        )
    }

    public var isFormValid: Bool {
        isValidEmail(email) && !password.isEmpty
    }

    // MARK: - Email / Password login

    public func login() {
        guard validate() else { return }
        isLoading     = true
        errorMessage  = nil

        Task { @MainActor in
            let result = await signInUseCase.execute(
                email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                password: password
            )
            isLoading = false
            switch result {
            case .success(let session): completedSession = session
            case .failure(let error):   errorMessage    = error.userFacingMessage
            }
        }
    }

    // MARK: - Google Sign-In

    public func signInWithGoogle() {
        isLoading        = true
        errorMessage     = nil
        pendingSocialUser = nil

        Task { @MainActor in
            let result = await signInWithSocialUseCase.execute(provider: .google)
            isLoading = false
            switch result {
            case .success(let socialResult):
                // With REST API, both new and existing users complete immediately
                switch socialResult {
                case .existingUser(let session), .newUser(let session):
                    completedSession = session
                }
            case .failure(let error):
                errorMessage = error.userFacingMessage
            }
        }
    }

    // MARK: - Validation

    private func validate() -> Bool {
        if !isValidEmail(email) {
            errorMessage = "Please enter a valid email address."
            return false
        }
        if password.isEmpty {
            errorMessage = "Password is required."
            return false
        }
        return true
    }

    private func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }
}
