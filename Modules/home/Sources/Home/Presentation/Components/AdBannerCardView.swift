//
//  AdBannerCardView.swift
//
//
//  Full-bleed, editorial-style promo card: the product image IS the card
//  (not a strip floating on a flat color block), with a bottom scrim for
//  text legibility and a slightly-rotated "sticker" discount badge as the
//  one deliberate visual accent. Modeled on how fashion/retail apps present
//  deals (Instagram-story-card energy) rather than a generic banner-ad look.
//

import SwiftUI

struct AdBannerCardView: View {
    let ad: Ad

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            backgroundLayer

            LinearGradient(
                colors: [.clear, .black.opacity(0.10), .black.opacity(0.78)],
                startPoint: .top,
                endPoint: .bottom
            )

            content
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(alignment: .topLeading) {
            if let badgeText = ad.badgeText {
                DiscountStickerView(text: badgeText)
                    .padding(14)
            }
        }
        .shadow(color: .black.opacity(0.18), radius: 12, x: 0, y: 8)
        .contentShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    @ViewBuilder
    private var backgroundLayer: some View {
        if let imageURL = ad.imageURL {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    // Loading state
                    ZStack {
                        fallbackBackground
                        ProgressView()
                            .tint(.white)
                    }
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    // Failed to load - show fallback
                    fallbackBackground
                @unknown default:
                    fallbackBackground
                }
            }
        } else {
            fallbackBackground
        }
    }

    private var fallbackBackground: some View {
        LinearGradient(
            colors: [DS.navy, Color(hex: "#3A2E5C")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay(
            Image(systemName: "sparkles")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white.opacity(0.10))
                .padding(48)
        )
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(ad.title)
                .font(.system(size: 19, weight: .heavy))
                .foregroundColor(.white)
                .lineLimit(2)
                .shadow(color: .black.opacity(0.35), radius: 3, y: 1)

            if let discountedPrice = ad.discountedPrice {
                HStack(spacing: 8) {
                    Text("$\(String(format: "%.2f", discountedPrice))")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)

                    if let originalPrice = ad.originalPrice, originalPrice > discountedPrice {
                        Text("$\(String(format: "%.2f", originalPrice))")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.62))
                            .strikethrough(true, color: .white.opacity(0.62))
                    }
                }
            } else if let subtitle = ad.subtitle {
                Text(subtitle)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.85))
            }

            HStack(spacing: 4) {
                Text(ad.ctaText)
                    .font(.system(size: 13, weight: .bold))
                Image(systemName: "arrow.right")
                    .font(.system(size: 11, weight: .bold))
            }
            .foregroundColor(DS.red)
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(.white, in: Capsule())
            .padding(.top, 4)
        }
        .padding(16)
    }
}

/// The one deliberately playful element on this card: a slightly rotated
/// "sticker" badge, distinct from the app's everyday red accent so a real
/// discount always reads as unmistakably different from normal chrome.
private struct DiscountStickerView: View {
    let text: String

    var body: some View {
        Text(text.uppercased())
            .font(.system(size: 12, weight: .heavy))
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(Color(hex: "#F5A623"))
            )
            .rotationEffect(.degrees(-4))
            .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
    }
}
