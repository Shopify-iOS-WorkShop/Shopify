import SwiftUI
import Common

public struct CartLineItemView: View {
    let line: CartLine
    let onIncrease: () -> Void
    let onDecrease: () -> Void
    let onRemove: () -> Void
    let onProductTap: () -> Void
    
    public init(
        line: CartLine,
        onIncrease: @escaping () -> Void,
        onDecrease: @escaping () -> Void,
        onRemove: @escaping () -> Void,
        onProductTap: @escaping () -> Void
    ) {
        self.line = line
        self.onIncrease = onIncrease
        self.onDecrease = onDecrease
        self.onRemove = onRemove
        self.onProductTap = onProductTap
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Product Image
            if let imageURL = line.imageURL {
                AsyncImage(url: imageURL) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .onTapGesture(perform: onProductTap)
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 80, height: 80)
                    .onTapGesture(perform: onProductTap)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                // Title and Delete
                HStack(alignment: .top) {
                    Text(line.productTitle)
                        .font(.headline)
                        .lineLimit(2)
                        .onTapGesture(perform: onProductTap)
                    
                    Spacer()
                    
                    Button(action: onRemove) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
                
                // Variant Title
                if !line.variantTitle.isEmpty && line.variantTitle.lowercased() != "default title" {
                    Text(line.variantTitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Price
                HStack {
                    Text(line.price.formatted)
                        .fontWeight(.bold)
                    
                    if let compareAt = line.compareAtPrice, compareAt.amount > line.price.amount {
                        Text(compareAt.formatted)
                            .strikethrough()
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }
                
                // Quantity Controls
                HStack {
                    Button(action: onDecrease) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.secondary)
                            .imageScale(.large)
                    }
                    
                    Text("\(line.quantity)")
                        .font(.body.monospacedDigit())
                        .frame(minWidth: 30, alignment: .center)
                    
                    Button(action: onIncrease) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.primary)
                            .imageScale(.large)
                    }
                    .disabled(line.quantityAvailable != nil && line.quantity >= line.quantityAvailable!)
                    
                    Spacer()
                    
                    if let available = line.quantityAvailable, available <= 5 {
                        Text("Only \(available) left")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}
