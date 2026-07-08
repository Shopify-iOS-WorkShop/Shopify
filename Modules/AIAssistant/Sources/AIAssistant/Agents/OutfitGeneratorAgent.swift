import Foundation

// MARK: - AI Outfit Generator Agent
// Fetches clothing products from Shopify, then uses Gemini to compose
// complete outfit suggestions validated against Agents.md.

public actor OutfitGeneratorAgent: AIAgent {

    public let agentType: AgentType = .outfitGenerator
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

    // MARK: - Generate outfits by occasion

    /// Returns outfit suggestions for a given occasion (e.g. "casual", "formal", "workout").
    public func generate(occasion: String, preferences: String? = nil) async throws -> [OutfitSuggestion] {
        let rules = await validator.loadAgentRules()

        // Fetch clothing products from Shopify
        var products: [ShopifyProduct] = []
        let clothingTypes = ["T-Shirt", "Shirt", "Pants", "Jeans", "Dress", "Jacket", "Shoes", "Accessories"]

        for type_ in clothingTypes.prefix(4) {
            let found = (try? await shopify.fetchProductsByType(type_)) ?? []
            for p in found where !products.contains(where: { $0.id == p.id }) {
                products.append(p)
            }
            if products.count >= config.maxProductsInContext { break }
        }

        // Fallback: general product fetch
        if products.isEmpty {
            products = (try? await shopify.fetchProducts()) ?? []
        }

        guard !products.isEmpty else { throw AIAssistantError.noProductsFound }

        let catalogBlock = products.enumerated().map { i, p in "[\(i + 1)] \(p.aiContext)" }.joined(separator: "\n\n")

        let preferenceBlock = preferences.map { "User preferences: \($0)" } ?? ""

        let prompt = """
        \(rules)

        You are an expert fashion stylist. Create 3 distinct complete outfit suggestions for the occasion: \(occasion.uppercased()).
        \(preferenceBlock)

        Use ONLY products from this catalog:
        \(catalogBlock)

        For each outfit provide:
        OUTFIT_1_TITLE: <name>
        OUTFIT_1_OCCASION: <occasion match note>
        OUTFIT_1_PRODUCTS: <product title 1>, <product title 2>, <product title 3>
        OUTFIT_1_DESCRIPTION: <2-sentence style description>
        OUTFIT_1_STYLE_NOTES: <1-sentence styling tip>

        OUTFIT_2_TITLE: <name>
        OUTFIT_2_OCCASION: <occasion match note>
        OUTFIT_2_PRODUCTS: <product title 1>, <product title 2>, <product title 3>
        OUTFIT_2_DESCRIPTION: <2-sentence style description>
        OUTFIT_2_STYLE_NOTES: <1-sentence styling tip>

        OUTFIT_3_TITLE: <name>
        OUTFIT_3_OCCASION: <occasion match note>
        OUTFIT_3_PRODUCTS: <product title 1>, <product title 2>, <product title 3>
        OUTFIT_3_DESCRIPTION: <2-sentence style description>
        OUTFIT_3_STYLE_NOTES: <1-sentence styling tip>

        Only use products that actually exist in the catalog above. Do not invent products.
        """

        let raw = try await gemini.generate(prompt: prompt)
        let clean = await validated(raw, validator: validator)

        return parseOutfits(from: clean, allProducts: products, occasion: occasion)
    }

    // MARK: - Generate outfit from a specific anchor product

    /// User taps a product → build an outfit around it.
    public func generateAround(productID: String, occasion: String = "everyday") async throws -> OutfitSuggestion {
        let rules = await validator.loadAgentRules()

        guard let anchor = try await shopify.fetchProduct(id: productID) else {
            throw AIAssistantError.noProductsFound
        }

        let allProducts = (try? await shopify.fetchProducts()) ?? []

        let catalogBlock = allProducts.prefix(20).enumerated().map { i, p in "[\(i + 1)] \(p.aiContext)" }.joined(separator: "\n\n")

        let prompt = """
        \(rules)

        Build a complete outfit around this ANCHOR product for the occasion: \(occasion).
        ANCHOR:
        \(anchor.aiContext)

        Choose 2–3 complementary products from this catalog to complete the outfit:
        \(catalogBlock)

        Format:
        OUTFIT_TITLE: <title>
        OUTFIT_PRODUCTS: \(anchor.title), <product 2>, <product 3>
        OUTFIT_DESCRIPTION: <2-sentence description>
        OUTFIT_STYLE_NOTES: <styling tip>
        """

        let raw = try await gemini.generate(prompt: prompt)
        let clean = await validated(raw, validator: validator)

        return parseSingleOutfit(from: clean, anchor: anchor, allProducts: allProducts, occasion: occasion)
    }

    // MARK: - Parsing

    private func parseOutfits(from raw: String, allProducts: [ShopifyProduct], occasion: String) -> [OutfitSuggestion] {
        var suggestions: [OutfitSuggestion] = []

        for index in 1...3 {
            let prefix = "OUTFIT_\(index)_"
            var title = "", occ = "", productsStr = "", desc = "", styleNotes = ""

            for line in raw.components(separatedBy: "\n") {
                let clean = line.trimmingCharacters(in: .whitespaces)
                if clean.hasPrefix("\(prefix)TITLE:") {
                    title = clean.replacingOccurrences(of: "\(prefix)TITLE:", with: "").trimmingCharacters(in: .whitespaces)
                } else if clean.hasPrefix("\(prefix)OCCASION:") {
                    occ = clean.replacingOccurrences(of: "\(prefix)OCCASION:", with: "").trimmingCharacters(in: .whitespaces)
                } else if clean.hasPrefix("\(prefix)PRODUCTS:") {
                    productsStr = clean.replacingOccurrences(of: "\(prefix)PRODUCTS:", with: "").trimmingCharacters(in: .whitespaces)
                } else if clean.hasPrefix("\(prefix)DESCRIPTION:") {
                    desc = clean.replacingOccurrences(of: "\(prefix)DESCRIPTION:", with: "").trimmingCharacters(in: .whitespaces)
                } else if clean.hasPrefix("\(prefix)STYLE_NOTES:") {
                    styleNotes = clean.replacingOccurrences(of: "\(prefix)STYLE_NOTES:", with: "").trimmingCharacters(in: .whitespaces)
                }
            }

            guard !title.isEmpty else { continue }

            let productTitles = productsStr.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            let products = productTitles.compactMap { title in
                allProducts.first { $0.title.lowercased().contains(title.lowercased()) }
            }

            suggestions.append(OutfitSuggestion(
                title: title.isEmpty ? "Outfit \(index)" : title,
                description: desc,
                products: products,
                occasion: occ.isEmpty ? occasion : occ,
                styleNotes: styleNotes
            ))
        }

        // If parsing failed entirely, create a basic suggestion
        if suggestions.isEmpty && !allProducts.isEmpty {
            suggestions.append(OutfitSuggestion(
                title: "Suggested Outfit",
                description: raw,
                products: Array(allProducts.prefix(3)),
                occasion: occasion,
                styleNotes: ""
            ))
        }

        return suggestions
    }

    private func parseSingleOutfit(from raw: String, anchor: ShopifyProduct, allProducts: [ShopifyProduct], occasion: String) -> OutfitSuggestion {
        var title = "", desc = "", styleNotes = "", productsStr = ""
        for line in raw.components(separatedBy: "\n") {
            let clean = line.trimmingCharacters(in: .whitespaces)
            if clean.hasPrefix("OUTFIT_TITLE:") { title = clean.replacingOccurrences(of: "OUTFIT_TITLE:", with: "").trimmingCharacters(in: .whitespaces) }
            else if clean.hasPrefix("OUTFIT_PRODUCTS:") { productsStr = clean.replacingOccurrences(of: "OUTFIT_PRODUCTS:", with: "").trimmingCharacters(in: .whitespaces) }
            else if clean.hasPrefix("OUTFIT_DESCRIPTION:") { desc = clean.replacingOccurrences(of: "OUTFIT_DESCRIPTION:", with: "").trimmingCharacters(in: .whitespaces) }
            else if clean.hasPrefix("OUTFIT_STYLE_NOTES:") { styleNotes = clean.replacingOccurrences(of: "OUTFIT_STYLE_NOTES:", with: "").trimmingCharacters(in: .whitespaces) }
        }

        let productTitles = productsStr.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        var products = productTitles.compactMap { t in allProducts.first { $0.title.lowercased().contains(t.lowercased()) } }
        if !products.contains(where: { $0.id == anchor.id }) { products.insert(anchor, at: 0) }

        return OutfitSuggestion(
            title: title.isEmpty ? "Outfit with \(anchor.title)" : title,
            description: desc.isEmpty ? raw : desc,
            products: products.isEmpty ? [anchor] : products,
            occasion: occasion,
            styleNotes: styleNotes
        )
    }
}
