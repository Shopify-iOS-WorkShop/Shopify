//
//  CartItemRowView.swift
//  Cart
//

import SwiftUI

struct CartItemRowView: View {
    let item: CartLineItem
    let onRemove: () -> Void
    let onIncrement: () -> Void
    let onDecrement: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Product Image
            Group {
                if let url = item.product.imageURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        default:
                            Color(.systemGray5)
                        }
                    }
                } else {
                    Color(.systemGray5)
                }
            }
            .frame(width: 90, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                // Title & Delete
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.product.title)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                            .lineLimit(2)

                        if let variant = item.variantTitle {
                            Text(variant)
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                    }

                    Spacer()

                    Button(action: onRemove) {
                        Image(systemName: "trash")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                }

                Spacer()

                // Stepper & Price
                HStack {
                    // Stepper
                    HStack(spacing: 0) {
                        Button(action: onDecrement) {
                            Text("−")
                                .font(.system(size: 18, weight: .medium))
                                .frame(width: 32, height: 32)
                                .foregroundColor(.primary)
                        }
                        .buttonStyle(.plain)

                        Text("\(item.quantity)")
                            .font(.system(size: 14, weight: .semibold))
                            .frame(minWidth: 24)
                            .multilineTextAlignment(.center)

                        Button(action: onIncrement) {
                            Text("+")
                                .font(.system(size: 18, weight: .medium))
                                .frame(width: 32, height: 32)
                                .foregroundColor(.primary)
                        }
                        .buttonStyle(.plain)
                    }
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                    Spacer()

                    Text(item.totalPrice.formatted)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}
