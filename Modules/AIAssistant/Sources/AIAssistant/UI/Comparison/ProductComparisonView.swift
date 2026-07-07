import SwiftUI


public struct ProductComparisonView: View {

    let agent: ProductComparisonAgent

    @State private var query = ""
    @State private var result: ComparisonResult?
    @State private var isLoading = false
    @State private var error: String?

    public init(agent: ProductComparisonAgent) {
        self.agent = agent
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Compare any two products")
                        .font(.headline)
                    HStack {
                        TextField("e.g. \"compare the red hoodie and black jacket\"", text: $query)
                            .textFieldStyle(.roundedBorder)
                            .onSubmit { compare() }
                        Button(action: compare) {
                            Image(systemName: "arrow.left.arrow.right.circle.fill")
                                .font(.title2)
                                .foregroundColor(.indigo)
                        }
                        .disabled(query.trimmingCharacters(in: .whitespaces).isEmpty || isLoading)
                    }
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Quick-start prompts
                if result == nil && !isLoading {
                    quickStartPrompts
                }

                // Loading state
                if isLoading {
                    ProgressView("Comparing products…")
                        .padding(40)
                }

                // Error
                if let error {
                    errorCard(message: error)
                }

                // Results
                if let result {
                    comparisonResultView(result)
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }


    private var quickStartPrompts: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Try these comparisons")
                .font(.subheadline)
                .foregroundColor(.secondary)
            ForEach([
                "Compare your two most popular items",
                "Which is better value, hoodie or jacket?",
                "Compare your cheapest and most expensive product"
            ], id: \.self) { prompt in
                Button {
                    query = prompt
                    compare()
                } label: {
                    HStack {
                        Image(systemName: "arrow.left.arrow.right.circle")
                            .foregroundColor(.indigo)
                        Text(prompt)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
        }
    }


    @ViewBuilder
    private func comparisonResultView(_ result: ComparisonResult) -> some View {
        VStack(spacing: 16) {
            // Product cards side by side
            HStack(alignment: .top, spacing: 12) {
                ForEach(result.products.prefix(2)) { product in
                    ProductCard(product: product)
                }
            }

            // Summary
            if !result.summary.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Label("Summary", systemImage: "text.alignleft")
                        .font(.caption).foregroundColor(.secondary)
                    Text(result.summary)
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // Dimension scores
            if !result.dimensionScores.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Label("Head-to-Head", systemImage: "chart.bar.xaxis")
                        .font(.caption).foregroundColor(.secondary)
                    ForEach(Array(result.dimensionScores.keys.sorted()), id: \.self) { dimension in
                        DimensionRow(dimension: dimension, scores: result.dimensionScores[dimension] ?? [:])
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // Recommendation
            if !result.recommendation.isEmpty {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "star.circle.fill")
                        .foregroundColor(.indigo)
                        .font(.title3)
                    Text(result.recommendation)
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.indigo.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // Reset button
            Button("Compare Different Products") {
                withAnimation { self.result = nil; query = "" }
            }
            .font(.subheadline)
            .foregroundColor(.indigo)
        }
    }

    private func errorCard(message: String) -> some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.orange)
            Text(message).font(.subheadline)
            Spacer()
            Button("Retry") { compare() }.foregroundColor(.indigo)
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }


    private func compare() {
        let q = query.trimmingCharacters(in: .whitespaces)
        guard !q.isEmpty else { return }
        error = nil
        isLoading = true
        result = nil

        Task {
            do {
                let res = try await agent.compare(query: q)
                await MainActor.run { result = res; isLoading = false }
            } catch {
                await MainActor.run { self.error = error.localizedDescription; isLoading = false }
            }
        }
    }
}


private struct ProductCard: View {
    let product: ShopifyProduct

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.indigo.opacity(0.1))
                .frame(height: 100)
                .overlay(
                    Image(systemName: "bag.fill")
                        .foregroundColor(.indigo.opacity(0.5))
                        .font(.largeTitle)
                )

            Text(product.title)
                .font(.caption).bold()
                .lineLimit(2)
            Text(product.minPrice)
                .font(.caption2)
                .foregroundColor(.indigo)
            if !product.productType.isEmpty {
                Text(product.productType)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}


private struct DimensionRow: View {
    let dimension: String
    let scores: [String: String]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(dimension.capitalized)
                .font(.caption2)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            HStack {
                ForEach(Array(scores.keys.sorted()), id: \.self) { key in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(key)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                        Text(scores[key] ?? "—")
                            .font(.caption)
                            .fontWeight(.medium)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        Divider()
    }
}
