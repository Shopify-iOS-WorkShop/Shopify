//
//  SwiftUIView.swift
//  search
//
//  Created by Al3dwy on 02/07/2026.
//

import SwiftUI

struct SearchFieldView: View {
    @Binding var text: String
    var onChange: (String) -> Void

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search products...", text: $text)
                .textFieldStyle(.plain)
                .autocorrectionDisabled()
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
        .onChange(of: text) { newValue in
            onChange(newValue)
        }
    }
}

#Preview {
    SearchFieldView(text: .constant(""), onChange: { _ in })
}
