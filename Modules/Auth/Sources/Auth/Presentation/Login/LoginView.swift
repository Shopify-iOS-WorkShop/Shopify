//
//  SwiftUIView.swift
//  Auth
//
//  Created by Al3dwy on 29/06/2026.
//

import SwiftUI
import Common

public struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 96, height: 96)
                
                Text("Welcome Back")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                Text("Log in to your PocketShop account")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                
                
                
            }
            
            
            VStack(spacing: 16) {
                CustomInputField(title: "Email", placeholder: "Enter your email", text: $email)
                CustomInputField(title: "Password", placeholder: "********", text: $password, isSecure: true)
            }
            
            PrimaryButton(title: "Login", icon: "arrow.right") {
                
            }
            
            SocialLoginRow(label: "OR LOGIN WITH",
                           onGoogleTap: {},
                           onAppleTap: {},
                           onFacebookTap: {})
        }
        .padding()
        
        HStack(spacing: 4) {
            
            Text("Don't have an account?")
                .font(.system(size: 15))
                .foregroundColor(.gray)
            Button(action: {
                
            }) {
                Text("Sign Up")
                    .font(.system(size: 15))
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 233 / 255.0, green: 69 / 255.0, blue: 96 / 255.0))
            }
        }
        }
        
        
    }
    
