import SwiftUI


public struct ProductComparisonView: View {

    let agent: ProductComparisonAgent
    let onProductSelected: ((ShopifyProduct) -> Void)?

    @State private var query = ""
    @State private var result: ComparisonResult?
    @State private var isLoading = false
    @State private var error: String?

    public init(agent: ProductComparisonAgent, onProductSelected: ((ShopifyProduct) -> Void)? = nil) {
        self.agent = agent
        self.onProductSelected = onProductSelected
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
                                .foregroundColor(DS.red)
                        }
                        .disabled(query.trimmingCharacters(in: .whitespaces).isEmpty || isLoading)
                    }
                }
                .padding()
                .background(DS.cardBG)
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
        .background(DS.background)
    }


    private var quickStartPrompts: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Try these comparisons")
                .font(.subheadline)
                .foregroundColor(DS.textSec)
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
                            .foregroundColor(DS.red)
                        Text(prompt)
                            .font(.subheadline)
                            .foregroundColor(DS.textPri)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(DS.textSec)
                    }
                    .padding()
                    .background(DS.cardBG)
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
                    ProductCard(product: product, onProductSelected: onProductSelected)
                }
            }

            // Summary
            if !result.summary.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Label("Summary", systemImage: "text.alignleft")
                        .font(.caption).foregroundColor(DS.textSec)
                    Text(result.summary)
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(DS.cardBG)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // Dimension scores
            if !result.dimensionScores.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Label("Head-to-Head", systemImage: "chart.bar.xaxis")
                        .font(.caption).foregroundColor(DS.textSec)
                    ForEach(Array(result.dimensionScores.keys.sorted()), id: \.self) { dimension in
                        DimensionRow(dimension: dimension, scores: result.dimensionScores[dimension] ?? [:])
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(DS.cardBG)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // Recommendation
            if !result.recommendation.isEmpty {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "star.circle.fill")
                        .foregroundColor(DS.red)
                        .font(.title3)
                    Text(result.recommendation)
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(DS.red.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // Reset button
            Button("Compare Different Products") {
                withAnimation { self.result = nil; query = "" }
            }
            .font(.subheadline)
            .foregroundColor(DS.red)
        }
    }

    private func errorCard(message: String) -> some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.orange)
            Text(message).font(.subheadline)
            Spacer()
            Button("Retry") { compare() }.foregroundColor(DS.red)
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
    let onProductSelected: ((ShopifyProduct) -> Void)?

    var body: some View {
        Button {
            onProductSelected?(product)
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                if let imageURL = product.firstImageURL {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().scaledToFill()
                        case .empty:
                            ProgressView()
                        case .failure:
                            DS.fieldBG
                        @unknown default:
                            DS.fieldBG
                        }
                    }
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                Text(product.title)
                    .font(.caption).bold()
                    .foregroundColor(DS.textPri)
                    .lineLimit(2)
                Text(product.minPrice)
                    .font(.caption2)
                    .foregroundColor(DS.red)
                if !product.productType.isEmpty {
                    Text(product.productType)
                        .font(.caption2)
                        .foregroundColor(DS.textSec)
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(DS.cardBG)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .disabled(onProductSelected == nil)
    }
}


private struct DimensionRow: View {
    let dimension: String
    let scores: [String: String]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(dimension.capitalized)
                .font(.caption2)
                .foregroundColor(DS.textSec)
                .textCase(.uppercase)
            HStack {
                ForEach(Array(scores.keys.sorted()), id: \.self) { key in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(key)
                            .font(.caption2)
                            .foregroundColor(DS.textSec)
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
