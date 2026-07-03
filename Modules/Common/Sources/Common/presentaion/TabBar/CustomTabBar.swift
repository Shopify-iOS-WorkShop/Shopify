//
//  File.swift
//  
//
//  Created by Mazen Amr on 03/07/2026.
//

import Foundation
import SwiftUI

public struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    
    public init(selectedTab: Binding<Tab>) {
            self._selectedTab = selectedTab
    }
    
    public var body: some View {
        HStack {
            ForEach(Tab.allCases, id: \.self) { tab in
                Spacer()
                VStack(spacing: 4) {
                    Image(systemName: selectedTab == tab ? tab.activeIcon : tab.icon)
                        .font(.system(size: 20))
                    Text(tab.rawValue)
                        .font(.system(size: 11, weight: selectedTab == tab ? .bold : .medium))
                }
                .foregroundColor(selectedTab == tab ? .black : .gray)
                .onTapGesture {
                    selectedTab = tab
                }
                Spacer()
            }
        }
        .padding(.vertical, 12)
        .background(Color(uiColor: .systemBackground))
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: -2)
    }
}
