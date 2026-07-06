//
//  File.swift
//  
//
//  Created by Mazen Amr on 06/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct CheckoutResultView: View {
    let onTrackOrder: () -> Void
    let onContinueShopping: () -> Void
    
    public init(onTrackOrder: @escaping () -> Void, onContinueShopping: @escaping () -> Void) {
        self.onTrackOrder = onTrackOrder
        self.onContinueShopping = onContinueShopping
    }
    
    public var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.green)
            
            Text("Order Placed Successfully!")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 16)
            
            Spacer()
            
            VStack(spacing: 12) {
                Button(action: onTrackOrder) {
                    HStack {
                        Image(systemName: "box.truck")
                        Text("Track Order")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(DS.red)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                
                Button(action: onContinueShopping) {
                    Text("Continue Shopping")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(Color(red: 0.2, green: 0.24, blue: 0.3))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 0.2, green: 0.24, blue: 0.3), lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .navigationBarBackButtonHidden(true)
    }
}
