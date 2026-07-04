//
//  File.swift
//  
//
//  Created by Mazen Amr on 04/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct PaymentMethodButton: View {
    let title: String
    let icon: String
    let type: PaymentType
    @Binding var selectedMethod: PaymentType
    
    public init(title: String, icon: String, type: PaymentType, selectedMethod: Binding<PaymentType>) {
        self.title = title
        self.icon = icon
        self.type = type
        self._selectedMethod = selectedMethod
    }
    
    public var body: some View {
        let isSelected = selectedMethod == type
        Button(action: { selectedMethod = type }) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                Text(title)
            }
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(isSelected ? .white : .secondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? DS.red : Color.clear)
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(isSelected ? Color.clear : Color(.systemGray4), lineWidth: 1)
            )
        }
    }
}
