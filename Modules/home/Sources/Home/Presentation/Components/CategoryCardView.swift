//
//  File.swift
//  
//
//  Created by Mazen Amr on 27/06/2026.
//

import Foundation
public struct CategoryCardView: View {
    public let category: Category

    public var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 14)
                .fill(DS.navy)
                .frame(height: 90)

            VStack(alignment: .leading, spacing: 4) {
                Image(systemName: category.iconName)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(DS.red)

                Text(category.title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(14)
        }
    }
}

