//
//  SwiftUIView.swift
//  Common
//
//  Created by Al3dwy on 28/06/2026.
//

import SwiftUI

public struct SocialLoginRow: View {
    let label: LocalizedStringKey
    var onGoogleTap: () -> Void
    var onAppleTap: () -> Void
    var onFacebookTap: () -> Void

    public init(
        label: LocalizedStringKey,
        onGoogleTap: @escaping () -> Void,
        onAppleTap: @escaping () -> Void,
        onFacebookTap: @escaping () -> Void
    ) {
        self.label = label
        self.onGoogleTap = onGoogleTap
        self.onAppleTap = onAppleTap
        self.onFacebookTap = onFacebookTap
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 16) {
                VStack { Divider() }
                Text(label)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(DS.textSec)
                    .layoutPriority(1)
                VStack { Divider() }
            }
            

            HStack(spacing: 20) {
                SocialButton(iconName: "google_icon") { onGoogleTap() }
                SocialButton(iconName: "apple_icon") { onAppleTap() }
                SocialButton(iconName: "facebook_icon") { onFacebookTap() }
            }
        }
    }
}



