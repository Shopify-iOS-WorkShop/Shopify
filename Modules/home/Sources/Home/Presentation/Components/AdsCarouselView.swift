//
//  AdsCarouselView.swift
//
//
//  Peeking, snap-to-card carousel: the next card's edge is visible so it
//  reads as "there's more here", instead of a single full-width page that
//  hides everything but the current card. Auto-advances, but a manual swipe
//  always wins because it's driving the same `scrollPosition` binding.
//

import SwiftUI

public struct AdsCarouselView: View {
    let ads: [Ad]
    let onTap: (Ad) -> Void

    @State private var scrollPosition: Int?

    private let autoAdvanceTimer = Timer.publish(every: 4.5, on: .main, in: .common).autoconnect()

    public init(ads: [Ad], onTap: @escaping (Ad) -> Void) {
        self.ads = ads
        self.onTap = onTap
    }

    private var items: [Ad] {
        ads.isEmpty ? [Ad.fallback] : ads
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 14) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, ad in
                        AdBannerCardView(ad: ad)
                            .containerRelativeFrame(.horizontal, count: 10, span: 9, spacing: 14)
                            .id(index)
                            .onTapGesture { onTap(ad) }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $scrollPosition)
            .frame(height: 200)
            .onReceive(autoAdvanceTimer) { _ in
                guard items.count > 1 else { return }
                let current = scrollPosition ?? 0
                withAnimation(.easeInOut(duration: 0.5)) {
                    scrollPosition = (current + 1) % items.count
                }
            }
            .onChange(of: items.count) { _, newCount in
                if let current = scrollPosition, current >= newCount {
                    scrollPosition = 0
                }
            }

            if items.count > 1 {
                HStack(spacing: 6) {
                    ForEach(items.indices, id: \.self) { index in
                        Capsule()
                            .fill(index == (scrollPosition ?? 0) ? DS.red : DS.lightGray)
                            .frame(width: index == (scrollPosition ?? 0) ? 16 : 6, height: 6)
                            .animation(.easeInOut, value: scrollPosition)
                    }
                }
                .frame(maxWidth: .infinity)  // Center the indicators
            }
        }
    }
}
