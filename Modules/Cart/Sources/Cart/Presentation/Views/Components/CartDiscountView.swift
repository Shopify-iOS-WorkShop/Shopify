import SwiftUI
import Common

public struct CartDiscountView: View {
    let codes: [CartDiscount]
    @Binding var codeInput: String
    let isLoading: Bool
    let successMessage: String?
    let errorMessage: String?
    let onApply: () -> Void
    let onRemove: (String) -> Void
    
    public init(
        codes: [CartDiscount],
        codeInput: Binding<String>,
        isLoading: Bool,
        successMessage: String? = nil,
        errorMessage: String? = nil,
        onApply: @escaping () -> Void,
        onRemove: @escaping (String) -> Void
    ) {
        self.codes = codes
        self._codeInput = codeInput
        self.isLoading = isLoading
        self.successMessage = successMessage
        self.errorMessage = errorMessage
        self.onApply = onApply
        self.onRemove = onRemove
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Discount Code")
                .font(.headline)
            
            HStack(spacing: 12) {
                TextField("Enter code here", text: $codeInput)
                    .padding(.horizontal, 16)
                    .frame(height: 56)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .disabled(isLoading)
                
                Button(action: onApply) {
                    if isLoading {
                        ProgressView()
                            .frame(width: 80, height: 56)
                            .background(Color.accentColor.opacity(0.8))
                            .cornerRadius(12)
                    } else {
                        Text("Apply")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 80, height: 56)
                            .background(Color.accentColor)
                            .cornerRadius(12)
                    }
                }
                .disabled(codeInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)
            }
            
            if let success = successMessage {
                Text(success)
                    .font(.caption)
                    .foregroundColor(.green)
            }
            
            if let error = errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
            
            // Applied Codes
            if !codes.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Applied Discounts:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    ForEach(codes, id: \.code) { discount in
                        HStack {
                            Image(systemName: "tag.fill")
                                .foregroundColor(.green)
                            
                            Text(discount.code)
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            Button(action: { onRemove(discount.code) }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                            .disabled(isLoading)
                        }
                        .padding(10)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.green.opacity(0.3), lineWidth: 1)
                        )
                        
                        if !discount.applicable {
                            Text("This code does not apply to your current cart items.")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
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
