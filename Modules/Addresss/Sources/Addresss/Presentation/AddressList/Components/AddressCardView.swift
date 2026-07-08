//
//  AddressCardView.swift
//  Address
//
//  Created by Mina Nashaat on 05/07/2026.
//

import SwiftUI

struct AddressCardView: View {
    let address: Address
    let icon: String
    var canDelete: Bool = true
    let onEdit: () -> Void
    let onDelete: () -> Void
    var onSelect: (() -> Void)?
    var onSetDefault: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                ZStack {
                    Circle()
                        .fill(AddressDS.fieldBG)
                        .frame(width: 34, height: 34)
                    Image(systemName: icon)
                        .foregroundStyle(AddressDS.navy)
                        .font(.system(size: 15, weight: .semibold))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(address.recipientName)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AddressDS.textPri)
                    Text(address.mobileNumber)
                        .font(.footnote)
                        .foregroundStyle(AddressDS.textSec)
                }

                Spacer()

                if address.isDefault {
                    Text("DEFAULT")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(AddressDS.red, in: Capsule())
                }
            }

            Text(address.formattedDetails)
                .font(.footnote)
                .foregroundStyle(AddressDS.textSec)
                .fixedSize(horizontal: false, vertical: true)

            Divider()

            HStack(spacing: 20) {
                Button(action: onEdit) {
                    HStack(spacing: 4) {
                        Image(systemName: "pencil")
                        Text("Edit")
                    }
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(AddressDS.textPri)
                }

                Button(action: onDelete) {
                    HStack(spacing: 4) {
                        Image(systemName: "trash")
                        Text("Delete")
                    }
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(canDelete ? AddressDS.red : AddressDS.textSec.opacity(0.5))
                }
                .disabled(!canDelete)

                if let onSetDefault, !address.isDefault {
                    Button(action: onSetDefault) {
                        HStack(spacing: 4) {
                            Image(systemName: "star")
                            Text("Set as Default")
                        }
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(AddressDS.textPri)
                    }
                }

                Spacer()

                if let onSelect {
                    Button(action: onSelect) {
                        Text("Deliver here")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(AddressDS.red)
                    }
                }
            }
        }
        .padding(16)
        .background(AddressDS.cardBG, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 3)
    }
}
