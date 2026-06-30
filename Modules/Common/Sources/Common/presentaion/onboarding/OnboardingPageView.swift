//
//  OnboardingPageView.swift
//  Common
//
//  Created by Al3dwy on 27/06/2026.
//

import SwiftUI


public struct OnboardingPageView: View {
    public let page: OnboardingPage
    
    public init(page: OnboardingPage) {
        self.page = page
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: page.systemImage)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .foregroundColor(page.color)
                .padding()
            
            Text(page.title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(page.description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}
