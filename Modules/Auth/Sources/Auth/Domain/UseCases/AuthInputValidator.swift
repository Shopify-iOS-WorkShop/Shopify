import Foundation

enum AuthInputValidator {
    static func validateEmail(_ email: String) -> AuthError? {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmail.isEmpty else {
            return .validation("Email is required.")
        }

        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        guard trimmedEmail.range(of: pattern, options: .regularExpression) != nil else {
            return .validation("Please enter a valid email address.")
        }

        return nil
    }

    static func validatePassword(_ password: String) -> AuthError? {
        guard password.count >= 8 else {
            return .validation("Password must be at least 8 characters.")
        }

        return nil
    }

    static func validateConfirmedPassword(_ password: String, _ confirmPassword: String) -> AuthError? {
        if let passwordError = validatePassword(password) {
            return passwordError
        }

        guard password == confirmPassword else {
            return .validation("Passwords do not match.")
        }

        return nil
    }

    static func validateName(firstName: String, lastName: String) -> AuthError? {
        guard !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return .validation("First name is required.")
        }

        guard !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return .validation("Last name is required.")
        }

        return nil
    }
}
