//
//  OnboardingPage.swift
//  Common
//
//  Created by Al3dwy on 27/06/2026.
//

import SwiftUI

public struct OnboardingPage: Identifiable {
    public let id = UUID()
    public let title: String
    public let description: String
    public let systemImage: String
    public let color: Color
    
    public init(title: String, description: String, systemImage: String, color: Color) {
        self.title = title
        self.description = description
        self.systemImage = systemImage
        self.color = color
    }
}
