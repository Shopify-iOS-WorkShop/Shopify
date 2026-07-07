import Foundation

public enum SocialSignInResult: Equatable {
    case existingUser(Session)
    case newUser(Session) // REST API: new users complete registration immediately, no password needed
}
