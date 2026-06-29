import XCTest
@testable import Auth

final class AuthTests: XCTestCase {
    @available(iOS 13.0.0, *)
    func testRegistrationFormIsValidWhenRequiredFieldsAreValid() {
        let viewModel = makeRegistrationViewModel()

        viewModel.firstName = "Ahmed"
        viewModel.lastName = "Hassan"
        viewModel.email = "ahmed@example.com"
        viewModel.password = "123456"
        viewModel.confirmPassword = "123456"

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
        viewModel.password = "123456"
        viewModel.confirmPassword = "654321"

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
            registerUseCase: RegisterUseCase(repository: repository),
            googleSignInUseCase: GoogleSignInUseCase(repository: repository),
            continueAsGuestUseCase: ContinueAsGuestUseCase()
        )
    }
}

private final class AuthRepositoryMock: AuthRepositoryInterface {
    var currentUser: AuthUser?

    func login(email: String, password: String) async throws -> AuthUser {
        makeUser(email: email)
    }

    func register(email: String, password: String, name: String) async throws -> AuthUser {
        makeUser(email: email, displayName: name)
    }

    func signInWithGoogle() async throws -> AuthUser {
        makeUser(email: "google@example.com", providerID: "google.com")
    }

    func signOut() throws {
        currentUser = nil
    }

    func sendVerificationEmail() async throws {}

    private func makeUser(
        email: String,
        displayName: String? = nil,
        providerID: String = "password"
    ) -> AuthUser {
        let user = AuthUser(
            uid: "mock-user-id",
            email: email,
            displayName: displayName,
            photoURL: nil,
            isEmailVerified: false,
            phoneNumber: nil,
            providerID: providerID,
            creationDate: nil,
            lastSignInDate: nil
        )
        currentUser = user
        return user
    }
}
