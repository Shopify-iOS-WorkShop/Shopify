//
//  ProfileHeaderView.swift
//  Settings — Presentation
//

import SwiftUI
import Common

public struct ProfileHeaderView: View {
    let profile: CustomerProfile

    public init(profile: CustomerProfile) {
        self.profile = profile
    }

    public var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                DS.red,
                                DS.tertiary
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)

                Text(initials)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
            }

            VStack(spacing: 4) {
                Text(profile.fullName)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(DS.textPri)

                Text(profile.email)
                    .font(.subheadline)
                    .foregroundColor(DS.textSec)

                if let phone = profile.phone, !phone.isEmpty {
                    Text(phone)
                        .font(.caption)
                        .foregroundColor(DS.textSec)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(DS.cardBG)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(DS.lightGray, lineWidth: 1)
        }
    }

    private var initials: String {
        let first = profile.firstName.first.map(String.init) ?? ""
        let last  = profile.lastName.first.map(String.init) ?? ""
        return "\(first)\(last)".uppercased()
    }
}
