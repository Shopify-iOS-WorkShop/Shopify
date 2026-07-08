//
//  SwiftUIView.swift
//  Common
//
//  Created by Al3dwy on 28/06/2026.
//

import SwiftUI

public struct CustomInputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    @State private var isPasswordVisible: Bool = false

    public init(title: String, placeholder: String, text: Binding<String>, isSecure: Bool = false) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
                Text(title.uppercased())
                    .font(.caption)
                    .bold()
                    .foregroundColor(DS.textPri)
            
            ZStack(alignment: .trailing) {
                if isSecure && !isPasswordVisible {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
                
                if isSecure {
                    Button(action: { isPasswordVisible.toggle() }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(DS.textSec)
                    }
                    .padding(.trailing, 16)
                }
            }
            .padding()
            .frame(minHeight: 56)
            .background(DS.fieldBG)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(DS.lightGray, lineWidth: 1)
            }
        }
    }
}

#Preview {
    CustomInputField(title: "Password", placeholder: "Enter your password", text: .constant(""), isSecure: true)
        
}
