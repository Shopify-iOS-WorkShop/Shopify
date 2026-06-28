//
//  File.swift
//  
//
//  Created by Mazen Amr on 27/06/2026.
//

import Foundation
import SwiftUI
public struct SectionHeaderView: View {
    public let title: String
    public let hasViewAll: Bool

    public init(title: String, hasViewAll: Bool) {
        self.title = title
        self.hasViewAll = hasViewAll
    }

    public var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(DS.textPri)
            Spacer()
            if hasViewAll {
                Button("View All") {}
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(DS.red)
            }
        }
        .padding(.horizontal, 16)
    }
}
