//
//  SwiftUIView.swift
//  search
//
//  Created by Al3dwy on 02/07/2026.
//

import SwiftUI
import Common

struct ProductRow: View {
    let product: SearchProduct
    var onTap: ((SearchProduct) -> Void)?

    @Environment(CurrencyStore.self) private var currencyStore

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
                                    .foregroundColor(.pocketMuted)
                            }
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    ZStack {
                        Color.pocketChip
                        Image(systemName: "bag")
                            .foregroundColor(.pocketMuted)
                    }
                }
            }
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.pocketText)
                    .lineLimit(2)
                Text(product.vendor)
                    .font(.caption)
                    .foregroundColor(.pocketMuted)
                Text(currencyStore.convert(Double(product.price) ?? 0))
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(.pocketPink)
            }

            Spacer()
        }
        .padding(12)
        .background(Color.pocketCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.pocketBorder, lineWidth: 1)
        )
        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .onTapGesture { onTap?(product) }
    }
}
