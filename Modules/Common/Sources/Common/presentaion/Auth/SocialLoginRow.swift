//
//  SwiftUIView.swift
//  Common
//
//  Created by Al3dwy on 28/06/2026.
//

import SwiftUI

struct SocialLoginRow: View {
    let label: String
    var onGoogleTap: () -> Void
    var onAppleTap: () -> Void
    var onFacebookTap: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack { Divider() }
                Text(label)
                    .font(.footnote)
                    .foregroundColor(.gray)
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






