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
            .padding()
            .background(Color(.systemPink))
            .cornerRadius(25)
            .shadow(color: Color(.systemPink).opacity(0.3), radius: 10, x: 0, y: 5)
        }
    }
}

