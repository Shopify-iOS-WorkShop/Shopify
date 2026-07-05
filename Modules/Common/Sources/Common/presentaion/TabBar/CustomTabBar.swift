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
    var cartBadgeCount: Int
    
    public init(selectedTab: Binding<Tab>, cartBadgeCount: Int = 0) {
        self._selectedTab = selectedTab
        self.cartBadgeCount = cartBadgeCount
    }
    
    public var body: some View {
        HStack {
            ForEach(Tab.allCases, id: \.self) { tab in
                Spacer()
                VStack(spacing: 4) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: selectedTab == tab ? tab.activeIcon : tab.icon)
                            .font(.system(size: 20))
                        
                        // Show badge on cart tab
                        if tab == .cart && cartBadgeCount > 0 {
                            Text("\(cartBadgeCount)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .frame(minWidth: 16, minHeight: 16)
                                .background(Color.pink)
                                .clipShape(Circle())
                                .offset(x: 8, y: -6)
                        }
                    }
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
