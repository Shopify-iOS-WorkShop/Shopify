import Foundation

// MARK: - AI Product Comparison Agent
// Fetches the requested products from Shopify, then asks Gemini to produce
// a structured comparison validated against Agents.md rules.

public actor ProductComparisonAgent: AIAgent {

    public let agentType: AgentType = .productComparison
    public let config: AIAssistantConfig

    private let shopify: ShopifyService
    private let gemini: GeminiService
    private let validator: AgentValidator

    public init(config: AIAssistantConfig) {
        self.config = config
        self.shopify = ShopifyService(config: config)
        self.gemini = GeminiService(config: config)
        self.validator = AgentValidator()
    }

    // MARK: - Compare by natural-language query

    /// User says "compare the red hoodie and the black jacket" — this resolves both,
    /// fetches them from Shopify, and returns a structured ComparisonResult.
    public func compare(query: String) async throws -> ComparisonResult {
        let rules = await validator.loadAgentRules()

        // Fetch all products then let Gemini identify the two best matches
        let allProducts = try await shopify.fetchProducts()
        guard !allProducts.isEmpty else { throw AIAssistantError.noProductsFound }

        let context = AgentContext(products: allProducts, userQuery: query, agentRules: rules)

        // Step 1 — Ask Gemini to identify the two products to compare
        let identifyPrompt = buildPrompt(context: context, instruction: """
        The user wants to compare two products. From the catalog, identify the TWO products that best match the user's query.
        Reply with ONLY a JSON object in this exact format (no markdown fences):
        {"product1": "<exact title>", "product2": "<exact title>"}
        If fewer than two matching products exist, pick the two closest matches.
        """)

        let identifyRaw = try await gemini.generate(prompt: identifyPrompt)
        let titles = parseComparisonTitles(from: identifyRaw)

        // Resolve actual product objects
        let p1 = allProducts.first { $0.title.lowercased().contains(titles.0.lowercased()) } ?? allProducts[0]
        let p2 = allProducts.first { $0.title.lowercased().contains(titles.1.lowercased()) } ?? (allProducts.count > 1 ? allProducts[1] : allProducts[0])

        // Step 2 — Ask Gemini for a full structured comparison
        let comparePrompt = """
        \(rules)

        Compare these two products for a customer:

        PRODUCT A:
        \(p1.aiContext)

        PRODUCT B:
        \(p2.aiContext)

        Provide:
        1. A 2-sentence summary of each product.
        2. A side-by-side comparison across: Price, Style/Type, Best For, Value for Money.
        3. A final recommendation sentence starting with "I recommend..."

        Format response as:
        SUMMARY_A: <text>
        SUMMARY_B: <text>
        PRICE: A=<val> | B=<val>
        STYLE: A=<val> | B=<val>
        BEST_FOR: A=<val> | B=<val>
        VALUE: A=<val> | B=<val>
        RECOMMENDATION: <text>
        """

        let raw = try await gemini.generate(prompt: comparePrompt)
        let validated = await self.validated(raw, validator: validator)

        return parseComparisonResult(raw: validated, products: [p1, p2])
    }

    // MARK: - Compare specific product IDs

    public func compare(productIDs: [String]) async throws -> ComparisonResult {
        guard productIDs.count >= 2 else { throw AIAssistantError.noProductsFound }
        let rules = await validator.loadAgentRules()
        let products = try await shopify.fetchProductsByIDs(Array(productIDs.prefix(3)))
        guard products.count >= 2 else { throw AIAssistantError.noProductsFound }

        let context = AgentContext(products: products, userQuery: "Compare these products", agentRules: rules)

        let comparePrompt = buildPrompt(context: context, instruction: """
        Compare the products listed in the catalog for a customer.
        Format:
        SUMMARY_A: <text>
        SUMMARY_B: <text>
        PRICE: A=<val> | B=<val>
        STYLE: A=<val> | B=<val>
        BEST_FOR: A=<val> | B=<val>
        VALUE: A=<val> | B=<val>
        RECOMMENDATION: <text>
        """)

        let raw = try await gemini.generate(prompt: comparePrompt)
        let clean = await validated(raw, validator: validator)
        return parseComparisonResult(raw: clean, products: products)
    }

    // MARK: - Parsing

    private func parseComparisonTitles(from json: String) -> (String, String) {
        let cleaned = json.trimmingCharacters(in: .whitespacesAndNewlines)
        if let data = cleaned.data(using: .utf8),
           let dict = try? JSONSerialization.jsonObject(with: data) as? [String: String],
           let p1 = dict["product1"], let p2 = dict["product2"] {
            return (p1, p2)
        }
        return ("", "")
    }

    private func parseComparisonResult(raw: String, products: [ShopifyProduct]) -> ComparisonResult {
        var dimensions: [String: [String: String]] = [:]
        var recommendation = ""
        var summaryA = "", summaryB = ""

        for line in raw.components(separatedBy: "\n") {
            let parts = line.components(separatedBy: ":")
            guard parts.count >= 2 else { continue }
            let key = parts[0].trimmingCharacters(in: .whitespaces)
            let value = parts.dropFirst().joined(separator: ":").trimmingCharacters(in: .whitespaces)

            switch key {
            case "SUMMARY_A": summaryA = value
            case "SUMMARY_B": summaryB = value
            case "RECOMMENDATION": recommendation = value
            case "PRICE", "STYLE", "BEST_FOR", "VALUE":
                let sides = value.components(separatedBy: "|")
                var dim: [String: String] = [:]
                for side in sides {
                    let kv = side.trimmingCharacters(in: .whitespaces).components(separatedBy: "=")
                    if kv.count == 2 {
                        let productKey = kv[0] == "A" ? (products.first?.title ?? "A") : (products.dropFirst().first?.title ?? "B")
                        dim[productKey] = kv[1].trimmingCharacters(in: .whitespaces)
                    }
                }
                dimensions[key.lowercased().replacingOccurrences(of: "_", with: " ")] = dim
            default: break
            }
        }

        let summary = [summaryA.isEmpty ? nil : "A: \(summaryA)", summaryB.isEmpty ? nil : "B: \(summaryB)"]
            .compactMap { $0 }.joined(separator: "\n")

        return ComparisonResult(
            products: products,
            summary: summary.isEmpty ? raw : summary,
            recommendation: recommendation.isEmpty ? "Both products have their merits — choose based on your needs." : recommendation,
            dimensionScores: dimensions
        )
    }
}
