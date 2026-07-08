//
//  OrderRowView.swift
//  Settings — Presentation
//

import SwiftUI
import Common

public struct OrderRowView: View {
    let order: CustomerOrder
    let viewModel: SettingsViewModel

    public init(order: CustomerOrder, viewModel: SettingsViewModel) {
        self.order = order
        self.viewModel = viewModel
    }

    public var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(UIColor.tertiarySystemFill))
                    .frame(width: 52, height: 52)

                if let url = order.firstItemImageURL {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Image(systemName: "bag")
                            .foregroundColor(DS.textSec)
                    }
                    .frame(width: 52, height: 52)
                    .clipped()
                    .cornerRadius(8)
                } else {
                    Image(systemName: "bag")
                        .foregroundColor(DS.textSec)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Order #\(order.orderNumber)")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                if let title = order.firstItemTitle {
                    Text(title)
                        .font(.caption)
                        .foregroundColor(DS.textSec)
                        .lineLimit(1)
                }

                Text(formattedDate)
                    .font(.caption2)
                    .foregroundColor(DS.textSec)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(viewModel.convert(amount: Double(order.totalAmount) ?? 0.0))
                    .font(.subheadline)
                    .fontWeight(.medium)

                StatusBadge(status: order.financialStatus)
            }
        }
        .padding(.vertical, 4)
    }

    private var formattedDate: String {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f.string(from: order.processedAt)
    }
}

private struct StatusBadge: View {
    let status: String

    var body: some View {
        Text(status.capitalized)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(backgroundColor.opacity(0.15))
            .foregroundColor(backgroundColor)
            .cornerRadius(6)
    }

    private var backgroundColor: Color {
        switch status.lowercased() {
        case "paid":    return .green
        case "pending": return .orange
        case "refunded", "voided": return .red
        default: return .secondary
        }
    }
}
