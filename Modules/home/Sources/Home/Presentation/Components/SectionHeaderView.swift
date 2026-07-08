//
//  File.swift
//  
//
//  Created by Mazen Amr on 27/06/2026.
//

import Foundation
import SwiftUI
import Common

public struct SectionHeaderView: View {
    public let title: LocalizedStringKey
    public let hasViewAll: Bool
    public let onViewAllTapped: (() -> Void)?
    public init(title: LocalizedStringKey, hasViewAll: Bool, onViewAllTapped: (() -> Void)? = nil) {
        self.title = title
        self.hasViewAll = hasViewAll
        self.onViewAllTapped = onViewAllTapped
    }

    public var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(DS.textPri)
            Spacer()
            if hasViewAll {
                Button("View All") {
                    onViewAllTapped?()
                }
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(DS.red)
            }
        }
        .padding(.horizontal, 16)
    }
}
