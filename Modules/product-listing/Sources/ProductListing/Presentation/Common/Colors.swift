//
//  File.swift
//  
//
//  Created by Mazen Amr on 29/06/2026.
//

import Foundation
import SwiftUI
import UIKit
enum DS {
    static let primary    = Color(hex: "#1A1A2E")
    static let secondary  = Color(hex: "#E94560")
    static let tertiary   = Color(hex: "#0F3460")
    static let neutral    = Color(light: "#F8F9FA", dark: "#16213E")
    static let red        = secondary
    static let navy       = primary
    static let background = Color(light: "#F8F9FA", dark: "#1A1A2E")
    static let cardBG     = Color(light: "#FFFFFF", dark: "#16213E")
    static let textPri    = Color(light: "#1A1A2E", dark: "#F8F9FA")
    static let textSec    = Color(light: "#6F7280", dark: "#B6BDD4")
    static let lightGray  = Color(light: "#E7E9EE", dark: "#2B3654")
    static let chipBG     = Color(light: "#EEF0F4", dark: "#222B49")
    static let fieldBG    = Color(light: "#F1F2F5", dark: "#202842")
    static let border     = Color(light: "#DDE0E7", dark: "#3B4568")
    static let shadow     = Color(light: "#1A1A2E", dark: "#000000")
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
            let hex = traits.userInterfaceStyle == .dark ? dark : light
            return UIColor(hex: hex)
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
