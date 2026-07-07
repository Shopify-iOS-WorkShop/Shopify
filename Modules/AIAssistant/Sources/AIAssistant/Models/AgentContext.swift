//
//  AgentContext.swift
//  AIAssistant
//
//  Created by Ahmed Elkady on 07/07/2026.
//

import Foundation

public struct AgentContext: Sendable {
    public let products: [ShopifyProduct]
    public let history: [AIMessage]
    public let userQuery: String
    public let agentRules: String
    public let imageData: Data?
    public let metadata: [String: String]

    public init(products: [ShopifyProduct] = [], history: [AIMessage] = [],
                userQuery: String, agentRules: String,
                imageData: Data? = nil, metadata: [String: String] = [:]) {
        self.products = products; self.history = history
        self.userQuery = userQuery; self.agentRules = agentRules
        self.imageData = imageData; self.metadata = metadata
    }

    var productCatalogBlock: String {
        guard !products.isEmpty else { return "No products available." }
        return products.enumerated().map { i, p in "[\(i + 1)] \(p.aiContext)" }.joined(separator: "\n\n")
    }

    var historyBlock: String {
        history.suffix(10).map { "\($0.role.rawValue.capitalized): \($0.content)" }.joined(separator: "\n")
    }
}
