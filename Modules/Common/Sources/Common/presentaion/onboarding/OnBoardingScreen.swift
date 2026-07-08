//
//  OnBoardingScreen.swift
//  Common
//
//  Created by Al3dwy on 27/06/2026.
//

import SwiftUI

extension Color {
    static let onboardingTheme = DS.red
}

public struct OnBoardingScreen: View {
    @State private var currentPage = 0

    /// Called when the user taps "Get Started" on the last page, so the
    /// caller can mark onboarding as complete and move on to auth/home.
    private let onFinish: () -> Void

    public let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome to Shopify",
            description: "Discover a wide variety of products tailored just for you. Start your shopping journey today.",
            systemImage: "bag.circle.fill",
            color: .onboardingTheme
        ),
        OnboardingPage(
            title: "Secure Payments",
            description: "Experience seamless and secure checkout with multiple payment options available.",
            systemImage: "lock.shield.fill",
            color: .onboardingTheme
        ),
        OnboardingPage(
            title: "Fast Delivery",
            description: "Get your favorite items delivered right to your doorstep in no time.",
            systemImage: "shippingbox.circle.fill",
            color: .onboardingTheme
        )
    ]
    
    public init(onFinish: @escaping () -> Void = {}) {
        self.onFinish = onFinish
    }

    public var body: some View {
        VStack {
             
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                .animation(.easeInOut, value: currentPage)
                .onAppear {
                    UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(DS.red)
                    UIPageControl.appearance().pageIndicatorTintColor = UIColor(DS.red.opacity(0.2))
                }
            
            Spacer()
            
            HStack {
                if currentPage < pages.count - 1 {
                    Button(action: {
                        withAnimation {
                            currentPage = pages.count - 1
                        }
                    }) {
                        Text("Skip")
                            .foregroundColor(DS.textSec)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            currentPage += 1
                        }
                    }) {
                        Text("Next")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 100)
                            .background(DS.red)
                            .cornerRadius(10)
                    }
                } else {
                    Button(action: {
                        onFinish()
                    }) {
                        Text("Get Started")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(DS.red)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
            }
            .padding()
        }
    }
}
//
//#Preview {
//    OnBoardingScreen()
//}
