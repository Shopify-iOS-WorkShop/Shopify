//
//  File.swift
//  
//
//  Created by Mazen Amr on 27/06/2026.
//

import Foundation
import SwiftUI
import Common

public struct FlashSaleBannerView: View {
    public init() {}

    public var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "#C0112F"), Color(hex: "#E8193C")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 160)

            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 120, height: 160)
                    .overlay(
                        Image(systemName: "figure.walk")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white.opacity(0.25))
                            .frame(height: 100)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("LIMITED TIME")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.white.opacity(0.85))
                    .tracking(1.5)

                Text("Flash sale Up to\n50% Off")
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundColor(.white)
                    .lineSpacing(2)

                Spacer().frame(height: 4)

                Button(action: {}) {
                    Text("Shop Now")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(DS.red)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .clipShape(Capsule())
                }
            }
            .padding(.leading, 20)
            .padding(.vertical, 20)
        }
    }
}
