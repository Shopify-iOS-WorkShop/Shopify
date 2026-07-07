import Foundation

// MARK: - AI Image Search Agent
// User uploads a photo → Gemini vision describes it → Shopify is queried
// for matching products → Gemini ranks and explains the matches.

public actor ImageSearchAgent: AIAgent {

    public let agentType: AgentType = .imageSearch
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

    // MARK: - Main entry point

    /// Searches the Shopify catalog for products visually similar to the provided image.
    /// - Parameters:
    ///   - imageData: JPEG or PNG data from the user's camera/photo library.
    ///   - additionalQuery: Optional text hint (e.g. "under $50").
    /// - Returns: An ImageSearchResult with matched products and an explanation.
    public func search(imageData: Data, additionalQuery: String? = nil) async throws -> ImageSearchResult {
        guard imageData.count <= 4 * 1024 * 1024 else {
            throw AIAssistantError.imageTooLarge
        }

        let rules = await validator.loadAgentRules()

        // Step 1 — Ask Gemini to describe the image (visual features for matching)
        let describePrompt = """
        \(rules)

        Analyse this product image and describe:
        1. The type of item (clothing, shoes, accessory, home decor, etc.)
        2. Key visual attributes: colour, pattern, material, style, fit, occasion
        3. 3–5 search keywords a shopper would use to find this item

        Respond in this format (no markdown):
        ITEM_TYPE: <type>
        ATTRIBUTES: <comma-separated list>
        KEYWORDS: <comma-separated list>
        """

        let descriptionRaw = try await gemini.generate(prompt: describePrompt, imageData: imageData)
        let parsed = parseImageDescription(descriptionRaw)

        // Step 2 — Search Shopify with the extracted keywords
        var allMatches: [ShopifyProduct] = []
        for keyword in parsed.keywords.prefix(3) {
            let results = (try? await shopify.fetchProducts(query: keyword)) ?? []
            for product in results where !allMatches.contains(where: { $0.id == product.id }) {
                allMatches.append(product)
            }
        }

        // Fallback: type-based search
        if allMatches.isEmpty, !parsed.itemType.isEmpty {
            allMatches = (try? await shopify.fetchProductsByType(parsed.itemType)) ?? []
        }

        // Fallback: fetch all and let Gemini match
        if allMatches.isEmpty {
            allMatches = (try? await shopify.fetchProducts()) ?? []
        }

        guard !allMatches.isEmpty else { throw AIAssistantError.noProductsFound }

        // Step 3 — Ask Gemini to rank and explain the matches
        let catalogBlock = allMatches.prefix(15).enumerated().map { i, p in
            "[\(i + 1)] \(p.aiContext)"
        }.joined(separator: "\n\n")

        let rankPrompt = """
        \(rules)

        The user uploaded an image. Here is what I detected:
        Item type: \(parsed.itemType)
        Visual attributes: \(parsed.attributes.joined(separator: ", "))

        \(additionalQuery.map { "Additional requirement: \($0)" } ?? "")

        From these store products:
        \(catalogBlock)

        Select the TOP 3 most visually similar products and explain why each one matches.
        Format:
        MATCH_1: <product title> | REASON: <1 sentence>
        MATCH_2: <product title> | REASON: <1 sentence>
        MATCH_3: <product title> | REASON: <1 sentence>
        SUMMARY: <2-sentence overall explanation>
        CONFIDENCE: <0–100>
        """

        let rankRaw = try await gemini.generate(prompt: rankPrompt)
        let clean = await validated(rankRaw, validator: validator)

        return parseSearchResult(raw: clean, allProducts: allMatches)
    }

    // MARK: - Text-based visual search

    public func search(description: String) async throws -> ImageSearchResult {
        let rules = await validator.loadAgentRules()
        let products = try await shopify.fetchProducts(query: description)
        guard !products.isEmpty else { throw AIAssistantError.noProductsFound }

        let context = AgentContext(products: products, userQuery: description, agentRules: rules)
        let prompt = buildPrompt(context: context, instruction: """
        Find the products from the catalog that best match this description.
        List up to 3 matches with a reason for each.
        Format:
        MATCH_1: <title> | REASON: <reason>
        MATCH_2: <title> | REASON: <reason>
        MATCH_3: <title> | REASON: <reason>
        SUMMARY: <summary>
        CONFIDENCE: 80
        """)

        let raw = try await gemini.generate(prompt: prompt)
        let clean = await validated(raw, validator: validator)
        return parseSearchResult(raw: clean, allProducts: products)
    }

    // MARK: - Parsing

    private struct ImageDescription {
        var itemType: String = ""
        var attributes: [String] = []
        var keywords: [String] = []
    }

    private func parseImageDescription(_ raw: String) -> ImageDescription {
        var result = ImageDescription()
        for line in raw.components(separatedBy: "\n") {
            let parts = line.components(separatedBy: ":")
            guard parts.count >= 2 else { continue }
            let key = parts[0].trimmingCharacters(in: .whitespaces)
            let value = parts.dropFirst().joined(separator: ":").trimmingCharacters(in: .whitespaces)
            switch key {
            case "ITEM_TYPE": result.itemType = value
            case "ATTRIBUTES": result.attributes = value.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            case "KEYWORDS": result.keywords = value.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            default: break
            }
        }
        return result
    }

    private func parseSearchResult(raw: String, allProducts: [ShopifyProduct]) -> ImageSearchResult {
        var matchedTitles: [String] = []
        var summary = ""
        var confidence = 75.0

        for line in raw.components(separatedBy: "\n") {
            if line.hasPrefix("MATCH_") {
                let afterColon = line.components(separatedBy: ":").dropFirst().joined(separator: ":")
                let title = afterColon.components(separatedBy: "|").first?.trimmingCharacters(in: .whitespaces) ?? ""
                if !title.isEmpty { matchedTitles.append(title) }
            } else if line.hasPrefix("SUMMARY:") {
                summary = line.replacingOccurrences(of: "SUMMARY:", with: "").trimmingCharacters(in: .whitespaces)
            } else if line.hasPrefix("CONFIDENCE:") {
                let val = line.replacingOccurrences(of: "CONFIDENCE:", with: "").trimmingCharacters(in: .whitespaces)
                confidence = Double(val) ?? 75.0
            }
        }

        let matched = matchedTitles.compactMap { title in
            allProducts.first { $0.title.lowercased().contains(title.lowercased()) }
        }

        let finalProducts = matched.isEmpty ? Array(allProducts.prefix(3)) : Array(matched.prefix(3))

        return ImageSearchResult(
            matchedProducts: finalProducts,
            summary: summary.isEmpty ? raw : summary,
            confidence: min(confidence / 100.0, 1.0)
        )
    }
}
