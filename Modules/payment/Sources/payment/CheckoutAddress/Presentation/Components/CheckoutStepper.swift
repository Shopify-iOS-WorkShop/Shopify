//
//  File.swift
//  
//
//  Created by Mazen Amr on 03/07/2026.
//
import Foundation
import SwiftUI
import Common

public struct CheckoutStepper: View {
    public enum Step: Int, CaseIterable { case cart, address, payment }
    public let currentStep: Step

    public var body: some View {
        HStack(spacing: 0) {
            stepView(step: .cart, label: "Cart", activeTextColor: DS.red)
            line
            stepView(step: .address, label: "Address", activeTextColor: DS.red)
            line
            stepView(step: .payment, label: "Payment")
        }
        .padding(.horizontal, 20)
    }

    private func stepView(step: Step, label: String, activeTextColor: Color = DS.red) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(currentStep.rawValue >= step.rawValue ? DS.red : Color(.systemGray4))
                    .frame(width: 32, height: 32)
                
                if currentStep.rawValue > step.rawValue {
                    Image(systemName: "checkmark").foregroundColor(.white).font(.system(size: 12, weight: .bold))
                } else {
                    Image(systemName: step == .cart ? "checkmark" : (step == .address ? "mappin" : "creditcard.fill"))
                        .foregroundColor(.white).font(.system(size: 14))
                }
            }
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(currentStep.rawValue >= step.rawValue ? activeTextColor : .secondary)
        }
    }

    private var line: some View {
        Rectangle()
            .frame(height: 2)
            .frame(maxWidth: 80)
            .foregroundColor(Color(.systemGray4))
            .offset(y: -12)
            .padding(.horizontal, 4)
    }
}
