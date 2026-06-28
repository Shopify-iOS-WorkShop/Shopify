//
//  SwiftUIView.swift
//  Common
//
//  Created by Al3dwy on 28/06/2026.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    var icon: String? = nil
    let action: () -> Void
    
    var body: some View {
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

#Preview {
    PrimaryButton()
}
