//
//  CouponCodeView.swift
//  Cart
//

import SwiftUI

struct CouponCodeView: View {
    @Binding var couponCode: String
    let isApplying: Bool
    let onApply: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("COUPON CODE")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.secondary)
                .kerning(0.5)

            HStack(spacing: 8) {
                TextField("Enter code", text: $couponCode)
                    .font(.system(size: 14))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                Button(action: onApply) {
                    Group {
                        if isApplying {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Apply")
                                .font(.system(size: 14, weight: .semibold))
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .disabled(couponCode.trimmingCharacters(in: .whitespaces).isEmpty || isApplying)
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}
