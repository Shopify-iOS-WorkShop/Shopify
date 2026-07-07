import SwiftUI

// MARK: - Outfit Generator View

public struct OutfitGeneratorView: View {

    let agent: OutfitGeneratorAgent

    @State private var selectedOccasion: String = "Casual"
    @State private var preferences = ""
    @State private var suggestions: [OutfitSuggestion] = []
    @State private var isLoading = false
    @State private var error: String?
    @State private var expandedOutfit: UUID?

    private let occasions = ["Casual", "Formal", "Date Night", "Workout", "Beach", "Office", "Party", "Weekend"]

    public init(agent: OutfitGeneratorAgent) {
        self.agent = agent
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                headerSection

                // Occasion picker
                occasionPicker

                // Preferences input
                preferencesInput

                // Generate button
                generateButton

                // Loading
                if isLoading {
                    ProgressView("Creating outfit suggestions…")
                        .padding(30)
                }

                // Error
                if let error {
                    errorBanner(error)
                }

                // Outfit suggestions
                if !suggestions.isEmpty {
                    outfitList
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }


    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "tshirt.fill")
                .font(.system(size: 36))
                .foregroundColor(.indigo)
            Text("AI Outfit Generator")
                .font(.title3).bold()
            Text("Tell us the occasion and we'll build complete outfits from our store.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }


    private var occasionPicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Occasion")
                .font(.subheadline).bold()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(occasions, id: \.self) { occasion in
                        Button {
                            selectedOccasion = occasion
                        } label: {
                            Text(occasion)
                                .font(.subheadline)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(selectedOccasion == occasion ? Color.indigo : Color(.secondarySystemGroupedBackground))
                                .foregroundColor(selectedOccasion == occasion ? .white : .primary)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }


    private var preferencesInput: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Style preferences (optional)")
                .font(.subheadline).bold()
            TextField("e.g. I prefer dark colours, no patterns", text: $preferences, axis: .vertical)
                .lineLimit(2...4)
                .textFieldStyle(.roundedBorder)
        }
    }


    private var generateButton: some View {
        Button(action: generate) {
            HStack {
                Image(systemName: "wand.and.stars")
                Text("Generate Outfits")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isLoading ? Color.gray : Color.indigo)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .disabled(isLoading)
    }


    private var outfitList: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your \(selectedOccasion) Outfits")
                .font(.headline)

            ForEach(suggestions) { suggestion in
                OutfitCard(
                    suggestion: suggestion,
                    isExpanded: expandedOutfit == suggestion.id,
                    onToggle: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            expandedOutfit = expandedOutfit == suggestion.id ? nil : suggestion.id
                        }
                    }
                )
            }

            Button("Regenerate Outfits") {
                generate()
            }
            .font(.subheadline)
            .foregroundColor(.indigo)
            .frame(maxWidth: .infinity)
        }
    }


    private func errorBanner(_ message: String) -> some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.orange)
            Text(message).font(.caption)
            Spacer()
            Button("Retry") { generate() }.foregroundColor(.indigo).font(.caption)
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }


    private func generate() {
        error = nil
        isLoading = true
        suggestions = []

        Task {
            do {
                let pref = preferences.trimmingCharacters(in: .whitespaces)
                let result = try await agent.generate(
                    occasion: selectedOccasion,
                    preferences: pref.isEmpty ? nil : pref
                )
                await MainActor.run {
                    suggestions = result
                    isLoading = false
                    if let first = result.first { expandedOutfit = first.id }
                }
            } catch {
                await MainActor.run {
                    self.error = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }
}


private struct OutfitCard: View {
    let suggestion: OutfitSuggestion
    let isExpanded: Bool
    let onToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header row
            Button(action: onToggle) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(suggestion.title)
                            .font(.subheadline).bold()
                            .foregroundColor(.primary)
                        Text(suggestion.occasion)
                            .font(.caption)
                            .foregroundColor(.indigo)
                    }
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding()
            }
            .buttonStyle(.plain)

            if isExpanded {
                Divider()
                VStack(alignment: .leading, spacing: 12) {
                    // Description
                    if !suggestion.description.isEmpty {
                        Text(suggestion.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    // Products
                    if !suggestion.products.isEmpty {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Products in this outfit")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .textCase(.uppercase)
                            ForEach(suggestion.products) { product in
                                OutfitProductRow(product: product)
                            }
                        }
                    }

                    // Style notes
                    if !suggestion.styleNotes.isEmpty {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.yellow)
                                .font(.caption)
                            Text(suggestion.styleNotes)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(10)
                        .background(Color.yellow.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                    // Shop now button
                    Button {
                        // Integration point: navigate to product or cart
                    } label: {
                        Label("Shop This Outfit", systemImage: "bag.fill")
                            .font(.subheadline).fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.indigo)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding()
            }
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}


private struct OutfitProductRow: View {
    let product: ShopifyProduct

    var body: some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.indigo.opacity(0.1))
                .frame(width: 40, height: 40)
                .overlay(Image(systemName: "tag.fill").foregroundColor(.indigo.opacity(0.5)).font(.caption))

            VStack(alignment: .leading, spacing: 2) {
                Text(product.title)
                    .font(.caption).bold()
                    .lineLimit(1)
                Text(product.minPrice)
                    .font(.caption2)
                    .foregroundColor(.indigo)
            }
            Spacer()
        }
    }
}
