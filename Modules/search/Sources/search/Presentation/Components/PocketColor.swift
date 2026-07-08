//
//  PocketColor.swift
//  search
//
//  Created by Al3dwy on 02/07/2026.
//
import SwiftUI
import UIKit



extension Color {
    static let pocketPrimary = Color(hex: "#1A1A2E")
    static let pocketPink = Color(hex: "#E94560")
    static let pocketTertiary = Color(hex: "#0F3460")
    static let pocketPinkSoft = Color(light: "#FDECEF", dark: "#3A2029")
    static let pocketBackground = Color(light: "#F8F9FA", dark: "#1A1A2E")
    static let pocketCard = Color(light: "#FFFFFF", dark: "#16213E")
    static let pocketChip = Color(light: "#EEF0F4", dark: "#222B49")
    static let pocketBorder = Color(light: "#DDE0E7", dark: "#3B4568")
    static let pocketText = Color(light: "#1A1A2E", dark: "#F8F9FA")
    static let pocketMuted = Color(light: "#6F7280", dark: "#B6BDD4")
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
        self.init(UIColor { traits in
            UIColor(hex: traits.userInterfaceStyle == .dark ? dark : light)
        })
    }
}

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
