//
//  LabeledField.swift
//  Address
//
//  Created by Mina Nashaat on 05/07/2026.
//

import SwiftUI

struct LabeledField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption)
                .foregroundStyle(AddressDS.textSec)

            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .environment(\.colorScheme, .light)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color.white, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }
}

struct DialCodeField: View {
    @Binding var dialCode: String
    @Binding var mobileNumber: String

    private let commonDialCodes = ["+1", "+20", "+44", "+971", "+966", "+91"]

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Mobile Number")
                .font(.caption)
                .foregroundStyle(AddressDS.textSec)

            HStack(spacing: 8) {
                Menu {
                    ForEach(commonDialCodes, id: \.self) { code in
                        Button(code) { dialCode = code }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(dialCode)
                            .foregroundStyle(AddressDS.textPri)
                        Image(systemName: "chevron.down")
                            .font(.caption2)
                            .foregroundStyle(AddressDS.textSec)
                    }
                    .environment(\.colorScheme, .light)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                }

                TextField("201 555-0123", text: $mobileNumber)
                    .keyboardType(.phonePad)
                    .environment(\.colorScheme, .light)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
    }
}

struct VerifiedBanner: View {
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(AddressDS.success)

            VStack(alignment: .leading, spacing: 2) {
                Text("Address Verified")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AddressDS.success)
                Text("This location matches official delivery records.")
                    .font(.caption)
                    .foregroundStyle(AddressDS.success.opacity(0.85))
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AddressDS.successBG, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}
