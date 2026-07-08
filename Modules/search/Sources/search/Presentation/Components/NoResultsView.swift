//
//  SwiftUIView.swift
//  search
//
//  Created by Al3dwy on 02/07/2026.
//

import SwiftUI

struct NoResultsView: View {
    var onBrowseCollections: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            ZStack {
                Circle()
                    .fill(Color.pocketPinkSoft)
                    .frame(width: 110, height: 110)
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 34, weight: .medium))
                    .foregroundColor(.pocketPink.opacity(0.5))
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.pocketPink.opacity(0.5))
                    .offset(x: 10, y: 10)
            }

            VStack(spacing: 6) {
                Text("No results found")
                    .font(.headline)
                    .foregroundColor(.pocketText)
                Text("We couldn't find any products matching your search. Try checking your spelling or use more general terms.")
                    .font(.subheadline)
                    .foregroundColor(.pocketMuted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

          

            Spacer()
            Spacer()
        }
    }
}

#Preview {
    NoResultsView(onBrowseCollections: {})
}
