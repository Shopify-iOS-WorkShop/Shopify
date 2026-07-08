import SwiftUI
import Common

public struct FavoriteProductCardView: View {
    public let product: FavoriteProduct
    public let onRemove: (String) -> Void
    public let onTap: (String) -> Void

    public init(
        product: FavoriteProduct,
        onRemove: @escaping (String) -> Void,
        onTap: @escaping (String) -> Void
    ) {
        self.product = product
        self.onRemove = onRemove
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: { onTap(product.id) }) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(DS.fieldBG)

                    if let url = product.imageURL {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .failure:
                                placeholderIcon
                            default:
                                ProgressView()
                            }
                        }
                    } else {
                        placeholderIcon
                    }
                }
                .frame(width: 90, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 12))

              
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.vendor.uppercased())
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(DS.red)
                        .tracking(0.8)

                    Text(product.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(DS.textPri)
                        .lineLimit(2)

                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(DS.red)
                        Text(String(format: "%.1f", product.rating))
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(DS.red)
                    }

                    Text("$\(String(format: "%.2f", product.price))")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(DS.textPri)
                }

                Spacer()

                
                Button(action: { onRemove(product.id) }) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 16))
                        .foregroundColor(DS.red)
                        .frame(width: 36, height: 36)
                        .background(DS.red.opacity(0.1))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
            .padding(12)
            .background(DS.cardBG)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(DS.lightGray.opacity(0.8), lineWidth: 1)
            }
            .shadow(color: DS.shadow.opacity(0.08), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(.plain)
    }

    private var placeholderIcon: some View {
        Image(systemName: "bag")
            .font(.system(size: 28, weight: .ultraLight))
            .foregroundColor(DS.textSec.opacity(0.45))
    }
}
