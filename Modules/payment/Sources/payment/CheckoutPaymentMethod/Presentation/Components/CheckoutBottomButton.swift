//
//  File.swift
//  
//
//  Created by Mazen Amr on 04/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct CheckoutBottomButton: View {
    let title: String
    let action: () -> Void
    
    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                Image(systemName: "arrow.right")
                    .font(.system(size: 16, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(DS.red)
            .cornerRadius(12)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
}
