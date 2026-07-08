//
//  AIAssistantConfig.swift
//  AIAssistant
//
//  Created by Ahmed Elkady on 07/07/2026.
//

import Foundation
import ShopifyNetwork
public enum AIProvider: String, Sendable {
    case gemini
    case groq
}

public struct AIAssistantConfig: Sendable {

    public let provider: AIProvider
    public let geminiAPIKey: String
    public let geminiModel: String
    public let groqAPIKey: String
    public let groqModel: String
    public let groqVisionModel: String

    public let shopifyHostname: String
    public let storefrontAccessToken: String
    public let apiVersion: String
    
    public let agenticMode: Bool
    public let maxProductsInContext: Int

    // ⚠️  Do NOT hard-code a real key here — this file IS committed.
    // Configure the real key at app start via:
    //   AIAssistantKit.configure(with: AIAssistantConfig(geminiAPIKey: Secrets.geminiAPIKey, ...))
    public static let shopWorkshop = AIAssistantConfig(
        provider:              .gemini,
        geminiAPIKey:          "",   // overridden by AIAssistantKit.configure(...)
        shopifyHostname:       ShopifyConfig.hostname,
        storefrontAccessToken: ShopifyConfig.storefrontToken,
        apiVersion:            ShopifyConfig.apiVersion,
        agenticMode:           true,
        maxProductsInContext:  20
    )

    public init(
        provider: AIProvider = .gemini,
        geminiAPIKey: String,
        geminiModel: String = "gemini-2.0-flash",
        groqAPIKey: String = "",
        groqModel: String = "llama-3.3-70b-versatile",
        groqVisionModel: String = "meta-llama/llama-4-scout-17b-16e-instruct",
        shopifyHostname: String,
        storefrontAccessToken: String,
        apiVersion: String = "2024-01",
        agenticMode: Bool = true,
        maxProductsInContext: Int = 20
    ) {
        self.provider              = provider
        self.geminiAPIKey          = geminiAPIKey
        self.geminiModel           = geminiModel
        self.groqAPIKey            = groqAPIKey
        self.groqModel             = groqModel
        self.groqVisionModel       = groqVisionModel
        self.shopifyHostname       = shopifyHostname
        self.storefrontAccessToken = storefrontAccessToken
        self.apiVersion            = apiVersion
        self.agenticMode           = agenticMode
        self.maxProductsInContext  = maxProductsInContext
    }

    var storefrontURL: URL {
        URL(string: "https://\(shopifyHostname)/api/\(apiVersion)/graphql.json")!
    }

    var geminiURL: URL {
        URL(string: "https://generativelanguage.googleapis.com/v1beta/models/\(geminiModel):generateContent?key=\(geminiAPIKey)")!
    }

    var groqChatCompletionsURL: URL {
        URL(string: "https://api.groq.com/openai/v1/chat/completions")!
    }
}
