//
//  SwiftUIView.swift
//  search
//
//  Created by Al3dwy on 02/07/2026.
//

import SwiftUI

struct ProductRow: View {
    let product: SearchProduct

    var body: some View {
        HStack(spacing: 14) {
            Group {
                if let url = product.imageUrl {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            Color.pocketChip
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure:
                            ZStack {
                                Color.pocketChip
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                            }
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    ZStack {
                        Color.pocketChip
                        Image(systemName: "bag")
                            .foregroundColor(.gray)
                    }
                }
            }
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(2)
                Text(product.vendor)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(product.price) \(product.currencyCode)")
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(.pocketPink)
            }

            Spacer()
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
    }
}
