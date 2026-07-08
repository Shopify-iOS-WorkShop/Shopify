//
//  AIMessage.swift
//  AIAssistant
//
//  Created by Ahmed Elkady on 07/07/2026.
//

import Foundation

public enum MessageRole: String, Codable, Sendable {
    case user, assistant, system
}

public struct AIMessage: Identifiable, Codable, Sendable {
    public let id: UUID
    public let role: MessageRole
    public let content: String
    public let timestamp: Date
    public var attachedProducts: [ShopifyProduct]

    public init(id: UUID = UUID(), role: MessageRole, content: String,
                timestamp: Date = Date(), attachedProducts: [ShopifyProduct] = []) {
        self.id = id; self.role = role; self.content = content
        self.timestamp = timestamp; self.attachedProducts = attachedProducts
    }
}

public struct ImageSearchResult: Identifiable, Sendable {
    public let id = UUID()
    public let matchedProducts: [ShopifyProduct]
    public let summary: String
    public let confidence: Double
}

public struct OutfitSuggestion: Identifiable, Sendable {
    public let id = UUID()
    public let title: String
    public let description: String
    public let products: [ShopifyProduct]
    public let occasion: String
    public let styleNotes: String
}

public struct ComparisonResult: Sendable {
    public let products: [ShopifyProduct]
    public let summary: String
    public let recommendation: String
    public let dimensionScores: [String: [String: String]]
}
