import XCTest
@testable import Auth

final class AuthTests: XCTestCase {
    @available(iOS 13.0.0, *)
    func testRegistrationFormIsValidWhenRequiredFieldsAreValid() {
        let viewModel = makeRegistrationViewModel()

        viewModel.firstName = "Ahmed"
        viewModel.lastName = "Hassan"
        viewModel.email = "ahmed@example.com"
        viewModel.password = "12345678"
        viewModel.confirmPassword = "12345678"

        XCTAssertTrue(viewModel.isFormValid)
        XCTAssertNil(viewModel.passwordMatchError)
        XCTAssertNil(viewModel.passwordLengthError)
    }

    @available(iOS 13.0.0, *)
    func testRegistrationFormIsInvalidWhenPasswordsDoNotMatch() {
        let viewModel = makeRegistrationViewModel()

        viewModel.firstName = "Ahmed"
        viewModel.lastName = "Hassan"
        viewModel.email = "ahmed@example.com"
        viewModel.password = "12345678"
        viewModel.confirmPassword = "87654321"

        XCTAssertFalse(viewModel.isFormValid)
        XCTAssertEqual(viewModel.passwordMatchError, "Passwords do not match")
    }

    @available(iOS 13.0.0, *)
    func testContinueAsGuestActivatesGuestSession() {
        let viewModel = makeRegistrationViewModel()

        let session = viewModel.continueAsGuest()

        XCTAssertEqual(session, .guest)
        XCTAssertEqual(viewModel.activeSession, .guest)
        XCTAssertTrue(viewModel.guestModeActivated)
    }

    @available(iOS 13.0.0, *)
    private func makeRegistrationViewModel() -> RegistrationViewModel {
        let repository = AuthRepositoryMock()
        return RegistrationViewModel(
            signUpUseCase: SignUpUseCase(repository: repository),
            signInWithSocialUseCase: SignInWithSocialUseCase(repository: repository),
            continueAsGuestUseCase: ContinueAsGuestUseCase()
        )
    }
}

private final class AuthRepositoryMock: AuthRepositoryProtocol {
    var currentSessionValue: Session?

    func signUp(email: String, password: String, firstName: String, lastName: String) async -> Result<Session, AuthError> {
        let session = makeSession()
        currentSessionValue = session
        return .success(session)
    }

    func signIn(email: String, password: String) async -> Result<Session, AuthError> {
        let session = makeSession()
        currentSessionValue = session
        return .success(session)
    }

    func signInWithSocial(provider: AuthProvider) async -> Result<SocialSignInResult, AuthError> {
        let session = makeSession()
        currentSessionValue = session
        return .success(.existingUser(session))
    }

    func setPasswordForSocialUser(email: String, password: String, firstName: String, lastName: String) async -> Result<Session, AuthError> {
        let session = makeSession()
        currentSessionValue = session
        return .success(session)
    }

    func signOut() async -> Result<Void, AuthError> {
        currentSessionValue = nil
        return .success(())
    }

    func recoverPassword(email: String) async -> Result<Void, AuthError> {
        .success(())
    }

    func currentSession() -> Session? {
        currentSessionValue
    }

    private func makeSession() -> Session {
        Session(
            customerAccessToken: "mock-token",
            expiresAt: Date().addingTimeInterval(3600),
            customerId: "gid://shopify/Customer/1",
            firebaseUID: "mock-user-id"
        )
    }
}
