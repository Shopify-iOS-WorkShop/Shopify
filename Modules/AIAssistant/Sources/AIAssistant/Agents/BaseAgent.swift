import Foundation

// MARK: - Base Agent Protocol
// Every AI agent reads Agents.md before building its prompt,
// then validates its response through AgentValidator before returning.

public protocol AIAgent: Sendable {
    var agentType: AgentType { get }
}

/// Shared helper methods available to all agents via extension.
extension AIAgent {

    // MARK: - Build grounded prompt

    /// Constructs a full prompt using the Agents.md system rules + product context + user query.
    func buildPrompt(context: AgentContext, instruction: String) -> String {
        """
        \(context.agentRules)

        === LIVE SHOPIFY PRODUCT CATALOG ===
        \(context.productCatalogBlock)
        =====================================

        \(context.historyBlock.isEmpty ? "" : "=== CONVERSATION HISTORY ===\n\(context.historyBlock)\n=============================\n")

        \(instruction)

        User query: \(context.userQuery)
        """
    }

    /// Validates a raw Gemini response through AgentValidator.
    func validated(_ raw: String, validator: AgentValidator) async -> String {
        let result = await validator.validate(response: raw, agentType: agentType)
        return result.cleanedResponse
    }
}
