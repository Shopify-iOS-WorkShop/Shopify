//
//  OnBoardingScreen.swift
//  Common
//
//  Created by Al3dwy on 27/06/2026.
//

import SwiftUI

extension Color {
    static let onboardingTheme = Color(red: 233 / 255.0, green: 69 / 255.0, blue: 96 / 255.0)
}

public struct OnBoardingScreen: View {
    @State private var currentPage = 0
    
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
    
    public init() {}

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
                    UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(red: 233 / 255.0, green: 69 / 255.0, blue: 96 / 255.0, alpha: 1.0)
                    UIPageControl.appearance().pageIndicatorTintColor = UIColor(red: 233 / 255.0, green: 69 / 255.0, blue: 96 / 255.0, alpha: 0.2)
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
                            .foregroundColor(.gray)
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
                            .background(Color.onboardingTheme)
                            .cornerRadius(10)
                    }
                } else {
                    Button(action: {
                       
                    }) {
                        Text("Get Started")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.onboardingTheme)
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
