//
//  SwiftUIView.swift
//  Common
//
//  Created by Al3dwy on 28/06/2026.
//

import SwiftUI

public struct SocialButton: View {
    let iconName: String
    let action: () -> Void

    public init(iconName: String, action: @escaping () -> Void) {
        self.iconName = iconName
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(Color(.systemGray6).opacity(0.5))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
        }
    }
    
}
