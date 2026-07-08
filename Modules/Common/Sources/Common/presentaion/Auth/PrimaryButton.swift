//
//  SwiftUIView.swift
//  Common
//
//  Created by Al3dwy on 28/06/2026.
//

import SwiftUI

public struct PrimaryButton: View {
    let title: String
    var icon: String? = nil
    let action: () -> Void

    public init(title: String, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.headline)
                if let icon = icon {
                    Image(systemName: icon)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .background(DS.red)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .primaryButtonStyle()
    }
}
