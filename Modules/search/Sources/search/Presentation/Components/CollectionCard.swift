//
//  SwiftUIView.swift
//  search
//
//  Created by Al3dwy on 02/07/2026.
//

import SwiftUI

struct CollectionCard: View {
    let collection: SearchCollection
    var onTap: ((SearchCollection) -> Void)?

    var body: some View {
        VStack(spacing: 8) {
            Group {
                if let url = collection.imageUrl {
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
                        Image(systemName: "folder")
                            .foregroundColor(.pocketMuted)
                    }
                }
            }
            .frame(width: 96, height: 96)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            Text(collection.title)
                .font(.caption.weight(.medium))
                .foregroundColor(.pocketText)
                .lineLimit(1)
                .frame(width: 96)
        }
        .contentShape(Rectangle())
        .onTapGesture { onTap?(collection) }
    }
}
