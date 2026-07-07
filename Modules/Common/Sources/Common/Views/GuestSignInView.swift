import SwiftUI

public struct GuestSignInView: View {
    let icon: String
    let title: String
    let message: String
    let onSignInTapped: () -> Void
    let onBrowseTapped: () -> Void
    
    public init(
        icon: String,
        title: String,
        message: String,
        onSignInTapped: @escaping () -> Void,
        onBrowseTapped: @escaping () -> Void
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.onSignInTapped = onSignInTapped
        self.onBrowseTapped = onBrowseTapped
    }
    
    public var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.secondary.opacity(0.5))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(message)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            VStack(spacing: 12) {
                PrimaryButton(
                    title: "Sign In",
                    action: onSignInTapped
                )
                .padding(.horizontal, 32)
                
                Button(action: onBrowseTapped) {
                    Text("Continue Browsing")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
            }
            .padding(.top, 16)
            
            Spacer()
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}
