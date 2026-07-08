import Foundation
import SwiftUI

public struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    var cartBadgeCount: Int
    /// Called on EVERY tap — including re-tapping the already-selected tab.
    /// Use this to pop-to-root when the active tab is tapped again.
    var onTabTapped: ((Tab) -> Void)?

    public init(
        selectedTab: Binding<Tab>,
        cartBadgeCount: Int = 0,
        onTabTapped: ((Tab) -> Void)? = nil
    ) {
        self._selectedTab   = selectedTab
        self.cartBadgeCount = cartBadgeCount
        self.onTabTapped    = onTabTapped
    }

    public var body: some View {
        HStack {
            ForEach(Tab.allCases, id: \.self) { tab in
                Spacer()
                VStack(spacing: 4) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: selectedTab == tab ? tab.activeIcon : tab.icon)
                            .font(.system(size: 20))

                        if tab == .cart && cartBadgeCount > 0 {
                            Text("\(cartBadgeCount)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .frame(minWidth: 16, minHeight: 16)
                                .background(DS.red)
                                .clipShape(Circle())
                                .offset(x: 8, y: -6)
                        }
                    }

                    Text(LocalizedStringKey(tab.rawValue))
                        .font(.system(size: 11, weight: selectedTab == tab ? .bold : .medium))
                }
                .foregroundColor(selectedTab == tab ? DS.textPri : DS.textSec)
                .padding(.vertical, 6)
                .padding(.horizontal, 8)
                .background(selectedTab == tab ? DS.chipBG : Color.clear, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .onTapGesture {
                    onTabTapped?(tab)   // always fires, even on re-tap of current tab
                    selectedTab = tab
                }
                Spacer()
            }
        }
        .padding(.vertical, 12)
        .background(DS.cardBG)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(DS.lightGray)
                .frame(height: 1)
        }
        .shadow(color: DS.shadow.opacity(0.06), radius: 8, x: 0, y: -3)
    }
}
