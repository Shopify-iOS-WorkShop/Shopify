//
//  File.swift
//
//
//  Created by Mazen Amr on 27/06/2026.
//

import Foundation
import SwiftUI

public enum DS {
    public static let red        = Color(hex: "#E8193C")
    public static let navy       = Color(hex: "#1C1F3B")
    public static let background = Color(hex: "#F7F7F7")
    public static let cardBG     = Color.white
    public static let textPri    = Color(hex: "#111111")
    public static let textSec    = Color(hex: "#888888")
    public static let lightGray  = Color(hex: "#D9D9D9")
}

public extension Color {
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
}
