import Foundation

public enum SocialSignInResult: Equatable {
    case existingUser(Session)
    case newUser(email: String, displayName: String?, provider: AuthProvider)
}
