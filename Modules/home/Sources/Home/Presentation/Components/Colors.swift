//
//  File.swift
//  
//
//  Created by Mazen Amr on 27/06/2026.
//

import Foundation
enum DS {
    static let red        = Color(hex: "#E8193C")
    static let navy       = Color(hex: "#1C1F3B")
    static let background = Color(hex: "#F7F7F7")
    static let cardBG     = Color.white
    static let textPri    = Color(hex: "#111111")
    static let textSec    = Color(hex: "#888888")
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
}
