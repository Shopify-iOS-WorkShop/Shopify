import SwiftUI
import Common

public struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @Environment(AuthCoordinator.self) private var coordinator

    public init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // MARK: Header
                VStack(spacing: 16) {
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 96, height: 96)

                    Text("Welcome Back")
                        .font(.system(size: 24))
                        .fontWeight(.bold)

                    Text("Log in to your PocketShop account")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
                .padding(.top, 40)

                // MARK: Fields
                VStack(spacing: 16) {
                    CustomInputField(title: "Email",    placeholder: "Enter your email", text: $viewModel.email)
                    CustomInputField(title: "Password", placeholder: "********",         text: $viewModel.password, isSecure: true)
                }

                // Forgot password
                HStack {
                    Spacer()
                    Button { coordinator.push(.forgotPassword) } label: {
                        Text("Forgot Password?")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(red: 233/255.0, green: 69/255.0, blue: 96/255.0))
                    }
                }

                // Error message
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.callout)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                // MARK: Actions
                VStack(spacing: 16) {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        PrimaryButton(title: "Login", icon: "arrow.right") {
                            viewModel.login()
                        }
                        .opacity(viewModel.isFormValid ? 1.0 : 0.6)
                        .disabled(!viewModel.isFormValid)
                    }
                }

                SocialLoginRow(
                    label: "OR LOGIN WITH",
                    onGoogleTap:   { viewModel.signInWithGoogle() },
                    onAppleTap:    {},
                    onFacebookTap: {}
                )
            }
            .padding()

            // MARK: Footer
            HStack(spacing: 4) {
                Text("Don't have an account?")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                Button { coordinator.push(.register) } label: {
                    Text("Sign Up")
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 233/255.0, green: 69/255.0, blue: 96/255.0))
                }
            }
            .padding(.bottom, 16)

            Button { coordinator.onContinueAsGuest?() } label: {
                Text("Continue as Guest")
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
                    .underline()
            }
            .padding(.bottom, 32)
        }
        // With REST API, both existing and new users complete login immediately
        .onReceive(viewModel.$completedSession.compactMap { $0 }) { _ in
            coordinator.onLoginSuccess?()
        }
        .navigationBarHidden(true)
    }
}
