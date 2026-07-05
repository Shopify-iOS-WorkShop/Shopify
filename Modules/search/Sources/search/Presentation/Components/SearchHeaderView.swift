//
//  SwiftUIView.swift
//  search
//
//  Created by Al3dwy on 02/07/2026.
//

import SwiftUI

struct SearchHeaderView: View {
    var body: some View {
        HStack {
            Text("PocketShop")
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: "cart")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }
}

#Preview {
    SearchHeaderView()
}
