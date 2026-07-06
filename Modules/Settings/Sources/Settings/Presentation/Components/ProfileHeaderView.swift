//
//  ProfileHeaderView.swift
//  Settings — Presentation
//

import SwiftUI

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
                                Color(red: 233/255, green: 69/255, blue: 96/255),
                                Color(red: 200/255, green: 50/255, blue: 80/255)
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

                Text(profile.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                if let phone = profile.phone, !phone.isEmpty {
                    Text(phone)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }

    private var initials: String {
        let first = profile.firstName.first.map(String.init) ?? ""
        let last  = profile.lastName.first.map(String.init) ?? ""
        return "\(first)\(last)".uppercased()
    }
}
