import SwiftUI

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
                        .fill(Color(.systemGray6))

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
                        .foregroundColor(.red)
                        .tracking(0.8)

                    Text(product.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(2)

                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.red)
                        Text(String(format: "%.1f", product.rating))
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.red)
                    }

                    Text("$\(String(format: "%.2f", product.price))")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.primary)
                }

                Spacer()

                
                Button(action: { onRemove(product.id) }) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.red)
                        .frame(width: 36, height: 36)
                        .background(Color.red.opacity(0.1))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
            .padding(12)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }

    private var placeholderIcon: some View {
        Image(systemName: "bag")
            .font(.system(size: 28, weight: .ultraLight))
            .foregroundColor(Color(.systemGray3))
    }
}
