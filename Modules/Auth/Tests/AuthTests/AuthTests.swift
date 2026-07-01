import XCTest
import Combine
@testable import Auth

// MARK: - Session Test Fixture

extension Session {
    static func mock(
        token: String = "mock-token-abc123",
        expiresAt: Date = Date().addingTimeInterval(86400),
        customerId: String? = "gid://shopify/Customer/9999",
        firebaseUID: String = "mock-firebase-uid"
    ) -> Session {
        Session(
            customerAccessToken: token,
            expiresAt: expiresAt,
            customerId: customerId,
            firebaseUID: firebaseUID
        )
    }
}

// MARK: - Mock Repository

private final class MockAuthRepository: AuthRepositoryProtocol {

    // MARK: Configurable stubs
    var signUpResult: Result<Session, AuthError>   = .success(.mock())
    var signInResult: Result<Session, AuthError>   = .success(.mock())
    var socialResult: Result<SocialSignInResult, AuthError> = .success(.existingUser(.mock()))
    var setPasswordResult: Result<Session, AuthError> = .success(.mock())
    var signOutResult: Result<Void, AuthError>     = .success(())
    var recoverResult: Result<Void, AuthError>     = .success(())
    var currentSessionValue: Session?              = .mock()

    // MARK: Call counters
    var signUpCallCount      = 0
    var signInCallCount      = 0
    var socialCallCount      = 0
    var setPasswordCallCount = 0
    var signOutCallCount     = 0
    var recoverCallCount     = 0

    // MARK: Last call args (for assertion)
    var lastSignUpEmail: String?
    var lastSignInEmail: String?
    var lastRecoverEmail: String?

    // MARK: Protocol impl
    func signUp(email: String, password: String, firstName: String, lastName: String) async -> Result<Session, AuthError> {
        signUpCallCount += 1
        lastSignUpEmail = email
        return signUpResult
    }

    func signIn(email: String, password: String) async -> Result<Session, AuthError> {
        signInCallCount += 1
        lastSignInEmail = email
        return signInResult
    }

    func signInWithSocial(provider: AuthProvider) async -> Result<SocialSignInResult, AuthError> {
        socialCallCount += 1
        return socialResult
    }

    func setPasswordForSocialUser(email: String, password: String, firstName: String, lastName: String) async -> Result<Session, AuthError> {
        setPasswordCallCount += 1
        return setPasswordResult
    }

    func signOut() async -> Result<Void, AuthError> {
        signOutCallCount += 1
        return signOutResult
    }

    func recoverPassword(email: String) async -> Result<Void, AuthError> {
        recoverCallCount += 1
        lastRecoverEmail = email
        return recoverResult
    }

    func currentSession() -> Session? {
        currentSessionValue
    }
}

// MARK: - Mock Use Cases

private final class MockSignInUseCase: SignInUseCaseProtocol {
    var result: Result<Session, AuthError> = .success(.mock())
    var callCount = 0
    func execute(email: String, password: String) async -> Result<Session, AuthError> {
        callCount += 1
        return result
    }
}

private final class MockSignUpUseCase: SignUpUseCaseProtocol {
    var result: Result<Session, AuthError> = .success(.mock())
    var callCount = 0
    func execute(email: String, password: String, confirmPassword: String, firstName: String, lastName: String) async -> Result<Session, AuthError> {
        callCount += 1
        return result
    }
}

private final class MockSignInWithSocialUseCase: SignInWithSocialUseCaseProtocol {
    var result: Result<SocialSignInResult, AuthError> = .success(.existingUser(.mock()))
    var callCount = 0
    func execute(provider: AuthProvider) async -> Result<SocialSignInResult, AuthError> {
        callCount += 1
        return result
    }
}

private final class MockRecoverPasswordUseCase: RecoverPasswordUseCaseProtocol {
    var result: Result<Void, AuthError> = .success(())
    var callCount = 0
    func execute(email: String) async -> Result<Void, AuthError> {
        callCount += 1
        return result
    }
}

private final class MockSetPasswordUseCase: SetPasswordForSocialUserUseCaseProtocol {
    var result: Result<Session, AuthError> = .success(.mock())
    var callCount = 0
    func execute(email: String, password: String, confirmPassword: String, firstName: String, lastName: String) async -> Result<Session, AuthError> {
        callCount += 1
        return result
    }
}

private final class MockContinueAsGuestUseCase: ContinueAsGuestUseCaseProtocol {
    func execute() -> UserSession { .guest }
}

// MARK: - SignUpUseCase Tests

final class SignUpUseCaseTests: XCTestCase {

    private var repository: MockAuthRepository!
    private var sut: SignUpUseCase!

    override func setUp() {
        super.setUp()
        repository = MockAuthRepository()
        sut = SignUpUseCase(repository: repository)
    }

    func test_execute_withValidInputs_callsRepositoryOnce() async {
        let result = await sut.execute(
            email: "ahmed@example.com",
            password: "password123",
            confirmPassword: "password123",
            firstName: "Ahmed",
            lastName: "Hassan"
        )
        XCTAssertEqual(repository.signUpCallCount, 1)
        if case .success(let session) = result {
            XCTAssertFalse(session.customerAccessToken.isEmpty)
        } else {
            XCTFail("Expected success, got \(result)")
        }
    }

    func test_execute_withEmptyEmail_returnsValidationError_withoutCallingRepository() async {
        let result = await sut.execute(
            email: "",
            password: "password123",
            confirmPassword: "password123",
            firstName: "Ahmed",
            lastName: "Hassan"
        )
        XCTAssertEqual(repository.signUpCallCount, 0)
        assertValidationFailure(result)
    }

    func test_execute_withInvalidEmailFormat_returnsValidationError() async {
        let result = await sut.execute(
            email: "not-an-email",
            password: "password123",
            confirmPassword: "password123",
            firstName: "Ahmed",
            lastName: "Hassan"
        )
        XCTAssertEqual(repository.signUpCallCount, 0)
        assertValidationFailure(result)
    }

    func test_execute_withShortPassword_returnsValidationError() async {
        let result = await sut.execute(
            email: "ahmed@example.com",
            password: "abc",
            confirmPassword: "abc",
            firstName: "Ahmed",
            lastName: "Hassan"
        )
        XCTAssertEqual(repository.signUpCallCount, 0)
        assertValidationFailure(result)
    }

    func test_execute_withMismatchedPasswords_returnsValidationError() async {
        let result = await sut.execute(
            email: "ahmed@example.com",
            password: "password123",
            confirmPassword: "different456",
            firstName: "Ahmed",
            lastName: "Hassan"
        )
        XCTAssertEqual(repository.signUpCallCount, 0)
        assertValidationFailure(result)
    }

    func test_execute_withEmptyFirstName_returnsValidationError() async {
        let result = await sut.execute(
            email: "ahmed@example.com",
            password: "password123",
            confirmPassword: "password123",
            firstName: "",
            lastName: "Hassan"
        )
        XCTAssertEqual(repository.signUpCallCount, 0)
        assertValidationFailure(result)
    }

    func test_execute_whenRepositoryFails_propagatesFailure() async {
        repository.signUpResult = .failure(.authentication("Firebase error"))
        let result = await sut.execute(
            email: "ahmed@example.com",
            password: "password123",
            confirmPassword: "password123",
            firstName: "Ahmed",
            lastName: "Hassan"
        )
        XCTAssertEqual(repository.signUpCallCount, 1)
        if case .failure(let error) = result {
            XCTAssertEqual(error, .authentication("Firebase error"))
        } else {
            XCTFail("Expected failure")
        }
    }
}

// MARK: - SignInUseCase Tests

final class SignInUseCaseTests: XCTestCase {

    private var repository: MockAuthRepository!
    private var sut: SignInUseCase!

    override func setUp() {
        super.setUp()
        repository = MockAuthRepository()
        sut = SignInUseCase(repository: repository)
    }

    func test_execute_withValidInputs_returnsSession() async {
        let result = await sut.execute(email: "ahmed@example.com", password: "password123")
        XCTAssertEqual(repository.signInCallCount, 1)
        if case .success = result { } else { XCTFail("Expected success") }
    }

    func test_execute_withEmptyEmail_returnsValidationError_noRepositoryCall() async {
        let result = await sut.execute(email: "", password: "password123")
        XCTAssertEqual(repository.signInCallCount, 0)
        assertValidationFailure(result)
    }

    func test_execute_withEmptyPassword_returnsValidationError() async {
        let result = await sut.execute(email: "ahmed@example.com", password: "")
        XCTAssertEqual(repository.signInCallCount, 0)
        assertValidationFailure(result)
    }

    func test_execute_whenRepositoryFails_propagatesFailure() async {
        repository.signInResult = .failure(.shopify("Invalid credentials"))
        let result = await sut.execute(email: "ahmed@example.com", password: "password123")
        if case .failure(let error) = result {
            XCTAssertEqual(error, .shopify("Invalid credentials"))
        } else {
            XCTFail("Expected failure")
        }
    }
}

// MARK: - RecoverPasswordUseCase Tests

final class RecoverPasswordUseCaseTests: XCTestCase {

    private var repository: MockAuthRepository!
    private var sut: RecoverPasswordUseCase!

    override func setUp() {
        super.setUp()
        repository = MockAuthRepository()
        sut = RecoverPasswordUseCase(repository: repository)
    }

    func test_execute_withValidEmail_callsRepository() async {
        let result = await sut.execute(email: "ahmed@example.com")
        XCTAssertEqual(repository.recoverCallCount, 1)
        XCTAssertEqual(repository.lastRecoverEmail, "ahmed@example.com")
        if case .success = result { } else { XCTFail("Expected success") }
    }

    func test_execute_withEmptyEmail_returnsValidationError_noRepositoryCall() async {
        let result = await sut.execute(email: "")
        XCTAssertEqual(repository.recoverCallCount, 0)
        assertValidationFailure(result)
    }

    func test_execute_withInvalidEmail_returnsValidationError() async {
        let result = await sut.execute(email: "bad-email")
        XCTAssertEqual(repository.recoverCallCount, 0)
        assertValidationFailure(result)
    }

    func test_execute_whenRepositoryFails_propagatesError() async {
        repository.recoverResult = .failure(.shopify("Email not found"))
        let result = await sut.execute(email: "ahmed@example.com")
        if case .failure(let error) = result {
            XCTAssertEqual(error, .shopify("Email not found"))
        } else {
            XCTFail("Expected failure")
        }
    }
}

// MARK: - SetPasswordForSocialUserUseCase Tests

final class SetPasswordForSocialUserUseCaseTests: XCTestCase {

    private var repository: MockAuthRepository!
    private var sut: SetPasswordForSocialUserUseCase!

    override func setUp() {
        super.setUp()
        repository = MockAuthRepository()
        sut = SetPasswordForSocialUserUseCase(repository: repository)
    }

    func test_execute_withValidInputs_callsRepository() async {
        let result = await sut.execute(
            email: "user@gmail.com",
            password: "password123",
            confirmPassword: "password123",
            firstName: "Ahmed",
            lastName: "Hassan"
        )
        XCTAssertEqual(repository.setPasswordCallCount, 1)
        if case .success = result { } else { XCTFail("Expected success") }
    }

    func test_execute_withShortPassword_returnsValidationError() async {
        let result = await sut.execute(
            email: "user@gmail.com",
            password: "short",
            confirmPassword: "short",
            firstName: "Ahmed",
            lastName: "Hassan"
        )
        XCTAssertEqual(repository.setPasswordCallCount, 0)
        assertValidationFailure(result)
    }

    func test_execute_withMismatchedPasswords_returnsValidationError() async {
        let result = await sut.execute(
            email: "user@gmail.com",
            password: "password123",
            confirmPassword: "different456",
            firstName: "Ahmed",
            lastName: "Hassan"
        )
        XCTAssertEqual(repository.setPasswordCallCount, 0)
        assertValidationFailure(result)
    }

    func test_execute_withEmptyFirstName_returnsValidationError() async {
        let result = await sut.execute(
            email: "user@gmail.com",
            password: "password123",
            confirmPassword: "password123",
            firstName: "",
            lastName: "Hassan"
        )
        XCTAssertEqual(repository.setPasswordCallCount, 0)
        assertValidationFailure(result)
    }
}

// MARK: - LoginViewModel Tests

@available(iOS 13.0, *)
final class LoginViewModelTests: XCTestCase {

    private var signInUseCase: MockSignInUseCase!
    private var socialUseCase: MockSignInWithSocialUseCase!
    private var sut: LoginViewModel!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        signInUseCase = MockSignInUseCase()
        socialUseCase = MockSignInWithSocialUseCase()
        sut = LoginViewModel(signInUseCase: signInUseCase, signInWithSocialUseCase: socialUseCase)
        cancellables = []
    }

    func test_isFormValid_withValidEmailAndPassword_isTrue() {
        sut.email = "ahmed@example.com"
        sut.password = "password123"
        XCTAssertTrue(sut.isFormValid)
    }

    func test_isFormValid_withInvalidEmail_isFalse() {
        sut.email = "not-valid"
        sut.password = "password123"
        XCTAssertFalse(sut.isFormValid)
    }

    func test_isFormValid_withEmptyPassword_isFalse() {
        sut.email = "ahmed@example.com"
        sut.password = ""
        XCTAssertFalse(sut.isFormValid)
    }

    func test_login_withValidForm_callsUseCaseAndSetsCompletedSession() async {
        sut.email = "ahmed@example.com"
        sut.password = "password123"

        let expectation = expectation(description: "completedSession published")
        sut.$completedSession
            .compactMap { $0 }
            .first()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)

        sut.login()
        await fulfillment(of: [expectation], timeout: 2)

        XCTAssertEqual(signInUseCase.callCount, 1)
        XCTAssertNotNil(sut.completedSession)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }

    func test_login_whenUseCaseFails_setsErrorMessage() async {
        sut.email = "ahmed@example.com"
        sut.password = "password123"
        signInUseCase.result = .failure(.authentication("Wrong credentials"))

        let expectation = expectation(description: "errorMessage published")
        sut.$errorMessage
            .compactMap { $0 }
            .first()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)

        sut.login()
        await fulfillment(of: [expectation], timeout: 2)

        XCTAssertNotNil(sut.errorMessage)
        XCTAssertNil(sut.completedSession)
    }

    func test_login_withInvalidForm_doesNotCallUseCase() {
        sut.email = "bad"
        sut.password = ""
        sut.login()
        XCTAssertEqual(signInUseCase.callCount, 0)
    }
}

// MARK: - RegistrationViewModel Tests

@available(iOS 13.0, *)
final class RegistrationViewModelTests: XCTestCase {

    private var signUpUseCase: MockSignUpUseCase!
    private var socialUseCase: MockSignInWithSocialUseCase!
    private var sut: RegistrationViewModel!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        signUpUseCase = MockSignUpUseCase()
        socialUseCase = MockSignInWithSocialUseCase()
        sut = RegistrationViewModel(
            signUpUseCase: signUpUseCase,
            signInWithSocialUseCase: socialUseCase,
            continueAsGuestUseCase: MockContinueAsGuestUseCase()
        )
        cancellables = []
    }

    func test_isFormValid_withAllValidFields_isTrue() {
        sut.fullName = "Ahmed Hassan"
        sut.email = "ahmed@example.com"
        sut.password = "password123"
        sut.confirmPassword = "password123"
        XCTAssertTrue(sut.isFormValid)
    }

    func test_isFormValid_withMismatchedPasswords_isFalse() {
        sut.fullName = "Ahmed Hassan"
        sut.email = "ahmed@example.com"
        sut.password = "password123"
        sut.confirmPassword = "different456"
        XCTAssertFalse(sut.isFormValid)
    }

    func test_passwordMatchError_whenPasswordsDontMatch_returnsError() {
        sut.password = "password123"
        sut.confirmPassword = "different456"
        XCTAssertEqual(sut.passwordMatchError, "Passwords do not match")
    }

    func test_passwordLengthError_whenPasswordTooShort_returnsError() {
        sut.password = "short"
        XCTAssertEqual(sut.passwordLengthError, "Password must be at least 8 characters")
    }

    func test_passwordLengthError_whenPasswordEmpty_isNil() {
        sut.password = ""
        XCTAssertNil(sut.passwordLengthError)
    }

    func test_register_success_setsCompletedSession() async {
        sut.fullName = "Ahmed Hassan"
        sut.email = "ahmed@example.com"
        sut.password = "password123"
        sut.confirmPassword = "password123"

        let expectation = expectation(description: "completedSession published")
        sut.$completedSession
            .compactMap { $0 }
            .first()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)

        sut.register()
        await fulfillment(of: [expectation], timeout: 2)

        XCTAssertEqual(signUpUseCase.callCount, 1)
        XCTAssertNotNil(sut.completedSession)
        XCTAssertNil(sut.errorMessage)
    }

    func test_register_failure_setsErrorMessage() async {
        sut.fullName = "Ahmed Hassan"
        sut.email = "ahmed@example.com"
        sut.password = "password123"
        sut.confirmPassword = "password123"
        signUpUseCase.result = .failure(.shopify("Email already taken"))

        let expectation = expectation(description: "errorMessage published")
        sut.$errorMessage
            .compactMap { $0 }
            .first()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)

        sut.register()
        await fulfillment(of: [expectation], timeout: 2)

        XCTAssertNotNil(sut.errorMessage)
        XCTAssertNil(sut.completedSession)
    }

    func test_continueAsGuest_returnsGuestSession() {
        let session = sut.continueAsGuest()
        XCTAssertEqual(session, .guest)
        XCTAssertTrue(sut.guestModeActivated)
    }
}

// MARK: - ForgotPasswordViewModel Tests

@available(iOS 13.0, *)
final class ForgotPasswordViewModelTests: XCTestCase {

    private var useCase: MockRecoverPasswordUseCase!
    private var sut: ForgotPasswordViewModel!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        useCase = MockRecoverPasswordUseCase()
        sut = ForgotPasswordViewModel(recoverPasswordUseCase: useCase)
        cancellables = []
    }

    func test_isFormValid_withValidEmail_isTrue() {
        sut.email = "ahmed@example.com"
        XCTAssertTrue(sut.isFormValid)
    }

    func test_isFormValid_withEmptyEmail_isFalse() {
        sut.email = ""
        XCTAssertFalse(sut.isFormValid)
    }

    func test_isFormValid_withInvalidEmail_isFalse() {
        sut.email = "not-valid"
        XCTAssertFalse(sut.isFormValid)
    }

    func test_sendResetEmail_success_setsIsEmailSentTrue() async {
        sut.email = "ahmed@example.com"

        let expectation = expectation(description: "isEmailSent = true")
        sut.$isEmailSent
            .filter { $0 }
            .first()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)

        sut.sendResetEmail()
        await fulfillment(of: [expectation], timeout: 2)

        XCTAssertEqual(useCase.callCount, 1)
        XCTAssertTrue(sut.isEmailSent)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }

    func test_sendResetEmail_failure_setsErrorMessage() async {
        sut.email = "ahmed@example.com"
        useCase.result = .failure(.shopify("Email not registered"))

        let expectation = expectation(description: "errorMessage published")
        sut.$errorMessage
            .compactMap { $0 }
            .first()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)

        sut.sendResetEmail()
        await fulfillment(of: [expectation], timeout: 2)

        XCTAssertFalse(sut.isEmailSent)
        XCTAssertNotNil(sut.errorMessage)
    }

    func test_sendResetEmail_withInvalidEmail_doesNotCallUseCase() {
        sut.email = "bad"
        sut.sendResetEmail()
        XCTAssertEqual(useCase.callCount, 0)
        XCTAssertNotNil(sut.errorMessage)
    }
}

// MARK: - SetPasswordViewModel Tests

@available(iOS 13.0, *)
final class SetPasswordViewModelTests: XCTestCase {

    private var useCase: MockSetPasswordUseCase!
    private var sut: SetPasswordViewModel!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        useCase = MockSetPasswordUseCase()
        sut = SetPasswordViewModel(
            email: "user@gmail.com",
            displayName: "Ahmed Hassan",
            setPasswordUseCase: useCase
        )
        cancellables = []
    }

    func test_init_presplitsDisplayNameIntoFirstAndLastName() {
        XCTAssertEqual(sut.firstName, "Ahmed")
        XCTAssertEqual(sut.lastName, "Hassan")
        XCTAssertEqual(sut.email, "user@gmail.com")
    }

    func test_init_withSingleWordDisplayName_setsFirstNameOnly() {
        let vm = SetPasswordViewModel(
            email: "user@gmail.com",
            displayName: "Ahmed",
            setPasswordUseCase: useCase
        )
        XCTAssertEqual(vm.firstName, "Ahmed")
        XCTAssertEqual(vm.lastName, "")
    }

    func test_init_withNilDisplayName_leavesNameEmpty() {
        let vm = SetPasswordViewModel(
            email: "user@gmail.com",
            displayName: nil,
            setPasswordUseCase: useCase
        )
        XCTAssertEqual(vm.firstName, "")
        XCTAssertEqual(vm.lastName, "")
    }

    func test_isFormValid_withValidInputs_isTrue() {
        sut.password = "password123"
        sut.confirmPassword = "password123"
        XCTAssertTrue(sut.isFormValid)
    }

    func test_isFormValid_withShortPassword_isFalse() {
        sut.password = "short"
        sut.confirmPassword = "short"
        XCTAssertFalse(sut.isFormValid)
    }

    func test_isFormValid_withMismatchedPasswords_isFalse() {
        sut.password = "password123"
        sut.confirmPassword = "different456"
        XCTAssertFalse(sut.isFormValid)
    }

    func test_passwordLengthError_whenShort_returnsError() {
        sut.password = "short"
        XCTAssertEqual(sut.passwordLengthError, "Password must be at least 8 characters")
    }

    func test_passwordMatchError_whenMismatch_returnsError() {
        sut.password = "password123"
        sut.confirmPassword = "different"
        XCTAssertEqual(sut.passwordMatchError, "Passwords do not match")
    }

    func test_confirm_withValidInputs_callsUseCaseAndSetsCompletedSession() async {
        sut.password = "password123"
        sut.confirmPassword = "password123"

        let expectation = expectation(description: "completedSession published")
        sut.$completedSession
            .compactMap { $0 }
            .first()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)

        sut.confirm()
        await fulfillment(of: [expectation], timeout: 2)

        XCTAssertEqual(useCase.callCount, 1)
        XCTAssertNotNil(sut.completedSession)
        XCTAssertNil(sut.errorMessage)
    }

    func test_confirm_whenUseCaseFails_setsErrorMessage() async {
        sut.password = "password123"
        sut.confirmPassword = "password123"
        useCase.result = .failure(.shopify("Customer already exists"))

        let expectation = expectation(description: "errorMessage published")
        sut.$errorMessage
            .compactMap { $0 }
            .first()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)

        sut.confirm()
        await fulfillment(of: [expectation], timeout: 2)

        XCTAssertNotNil(sut.errorMessage)
        XCTAssertNil(sut.completedSession)
    }

    func test_confirm_withInvalidForm_doesNotCallUseCase() {
        sut.password = "short"
        sut.confirmPassword = "short"
        sut.confirm()
        XCTAssertEqual(useCase.callCount, 0)
        XCTAssertNotNil(sut.errorMessage)
    }
}

// MARK: - Helpers

private func assertValidationFailure<T>(_ result: Result<T, AuthError>, file: StaticString = #file, line: UInt = #line) {
    if case .failure(let error) = result {
        if case .validation = error { return }
        XCTFail("Expected .validation error, got \(error)", file: file, line: line)
    } else {
        XCTFail("Expected failure, got success", file: file, line: line)
    }
}
