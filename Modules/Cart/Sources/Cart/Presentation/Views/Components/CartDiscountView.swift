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
                .foregroundColor(DS.textPri)
            
            HStack(spacing: 12) {
                TextField("Enter code here", text: $codeInput)
                    .padding(.horizontal, 16)
                    .frame(height: 56)
                    .foregroundColor(DS.textPri)
                    .background(DS.fieldBG)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(DS.lightGray, lineWidth: 1)
                    }
                    .disabled(isLoading)
                
                Button(action: onApply) {
                    if isLoading {
                        ProgressView()
                            .frame(width: 80, height: 56)
                            .background(DS.red.opacity(0.8))
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    } else {
                        Text("Apply")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 80, height: 56)
                            .background(DS.red)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
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
                    .foregroundColor(DS.red)
            }
            
            // Applied Codes
            if !codes.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Applied Discounts:")
                        .font(.subheadline)
                        .foregroundColor(DS.textSec)
                    
                    ForEach(codes, id: \.code) { discount in
                        HStack {
                            Image(systemName: "tag.fill")
                                .foregroundColor(.green)
                            
                            Text(discount.code)
                                .fontWeight(.medium)
                                .foregroundColor(DS.textPri)
                            
                            Spacer()
                            
                            Button(action: { onRemove(discount.code) }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(DS.textSec)
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
        .background(DS.cardBG)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(DS.lightGray, lineWidth: 1)
        }
    }
}
