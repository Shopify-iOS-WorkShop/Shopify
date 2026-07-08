//
//  DS.swift
//  Address
//
//  Created by Mina Nashaat on 05/07/2026.
//

import SwiftUI
import UIKit

enum AddressDS {
    static let red        = Color(hex: "#E94560")
    static let navy       = Color(hex: "#1A1A2E")
    static let tertiary   = Color(hex: "#0F3460")
    static let background = Color(light: "#F8F9FA", dark: "#1A1A2E")
    static let cardBG     = Color(light: "#FFFFFF", dark: "#16213E")
    static let textPri    = Color(light: "#1A1A2E", dark: "#F8F9FA")
    static let textSec    = Color(light: "#6F7280", dark: "#B6BDD4")
    static let lightGray  = Color(light: "#E7E9EE", dark: "#2B3654")
    static let fieldBG    = Color(light: "#F1F2F5", dark: "#202842")
    static let shadow     = Color(light: "#1A1A2E", dark: "#000000")
    static let success    = Color(hex: "#1FA36B")
    static let successBG  = Color(light: "#E5F7EE", dark: "#143D2B")
}

extension Color {
    init(hex: String) {
        let h = hex.trimmingCharacters(in: .init(charactersIn: "#"))
        var val: UInt64 = 0
        Scanner(string: h).scanHexInt64(&val)
        self.init(
            red:   Double((val >> 16) & 0xFF) / 255,
            green: Double((val >> 8)  & 0xFF) / 255,
            blue:  Double( val        & 0xFF) / 255
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
