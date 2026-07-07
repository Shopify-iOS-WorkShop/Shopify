//
//  AIAssistantConfig.swift
//  AIAssistant
//
//  Created by Ahmed Elkady on 07/07/2026.
//

import Foundation

public struct AIAssistantConfig: Sendable {

    public let geminiAPIKey: String
    public let geminiModel: String

    public let shopifyHostname: String
    public let storefrontAccessToken: String
    public let apiVersion: String
    
    public let agenticMode: Bool
    public let maxProductsInContext: Int

    // ⚠️  Do NOT hard-code a real key here — this file IS committed.
    // Configure the real key at app start via:
    //   AIAssistantKit.configure(with: AIAssistantConfig(geminiAPIKey: Secrets.geminiAPIKey, ...))
    public static let shopWorkshop = AIAssistantConfig(
        geminiAPIKey:          "",   // overridden by AIAssistantKit.configure(...)
        geminiModel:           "gemini-1.5-flash",
        shopifyHostname:       "mad46-ios-team5.myshopify.com",
        storefrontAccessToken: "8842c04427c5f8a6e967f204266cd8bf",
        apiVersion:            "2024-01",
        agenticMode:           true,
        maxProductsInContext:  20
    )

    public init(
        geminiAPIKey: String,
        geminiModel: String = "gemini-1.5-flash",
        shopifyHostname: String,
        storefrontAccessToken: String,
        apiVersion: String = "2024-01",
        agenticMode: Bool = true,
        maxProductsInContext: Int = 20
    ) {
        self.geminiAPIKey          = geminiAPIKey
        self.geminiModel           = geminiModel
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
}
