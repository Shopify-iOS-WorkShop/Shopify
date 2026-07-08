//
//  File.swift
//  
//
//  Created by Mazen Amr on 04/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct CardInputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var icon: String? = nil
    
    public init(title: String, placeholder: String, text: Binding<String>, icon: String? = nil) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.icon = icon
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(DS.textSec)
            
            HStack {
                TextField(placeholder, text: $text)
                    .font(.system(size: 16))
                    .foregroundColor(DS.textPri)
                    .keyboardType(.numberPad)
                
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(DS.textSec)
                }
            }
            .padding()
            .background(DS.fieldBG)
            .cornerRadius(8)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(DS.border, lineWidth: 1)
            }
        }
    }
}
