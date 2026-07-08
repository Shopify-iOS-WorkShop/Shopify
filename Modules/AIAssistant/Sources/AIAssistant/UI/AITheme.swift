import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

enum DS {
    static let primary = Color(hex: "#1A1A2E")
    static let secondary = Color(hex: "#E94560")
    static let tertiary = Color(hex: "#0F3460")
    static let red = secondary
    static let background = Color(light: "#F8F9FA", dark: "#1A1A2E")
    static let cardBG = Color(light: "#FFFFFF", dark: "#16213E")
    static let textPri = Color(light: "#1A1A2E", dark: "#F8F9FA")
    static let textSec = Color(light: "#6F7280", dark: "#B6BDD4")
    static let lightGray = Color(light: "#E7E9EE", dark: "#2B3654")
    static let fieldBG = Color(light: "#F1F2F5", dark: "#202842")
}

private extension Color {
    init(hex: String) {
        let h = hex.trimmingCharacters(in: .init(charactersIn: "#"))
        var val: UInt64 = 0
        Scanner(string: h).scanHexInt64(&val)
        self.init(
            red: Double((val >> 16) & 0xFF) / 255,
            green: Double((val >> 8) & 0xFF) / 255,
            blue: Double(val & 0xFF) / 255
        )
    }

    init(light: String, dark: String) {
        #if canImport(UIKit)
        self.init(UIColor { traits in
            UIColor(hex: traits.userInterfaceStyle == .dark ? dark : light)
        })
        #else
        self.init(hex: light)
        #endif
    }
}

#if canImport(UIKit)
private extension UIColor {
    convenience init(hex: String) {
        let h = hex.trimmingCharacters(in: .init(charactersIn: "#"))
        var val: UInt64 = 0
        Scanner(string: h).scanHexInt64(&val)
        self.init(
            red: CGFloat((val >> 16) & 0xFF) / 255,
            green: CGFloat((val >> 8) & 0xFF) / 255,
            blue: CGFloat(val & 0xFF) / 255,
            alpha: 1
        )
    }
}
#endif
