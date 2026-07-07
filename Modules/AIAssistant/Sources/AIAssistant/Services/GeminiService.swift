//
//  GeminiService.swift
//  AIAssistant
//
//  Created by Ahmed Elkady on 07/07/2026.
//

import Foundation

public actor GeminiService {

    private let config: AIAssistantConfig
    public init(config: AIAssistantConfig) { self.config = config }


    public func generate(prompt: String) async throws -> String {
        try await call(body: [
            "contents": [["parts": [["text": prompt]]]],
            "generationConfig": ["temperature": 0.7, "maxOutputTokens": 1024]
        ])
    }


    public func generate(prompt: String, imageData: Data, mimeType: String = "image/jpeg") async throws -> String {
        try await call(body: [
            "contents": [[
                "parts": [
                    ["text": prompt],
                    ["inline_data": ["mime_type": mimeType, "data": imageData.base64EncodedString()]]
                ]
            ]],
            "generationConfig": ["temperature": 0.5, "maxOutputTokens": 1024]
        ])
    }


    public func converse(history: [AIMessage], newMessage: String, systemPrompt: String) async throws -> String {
        var contents: [[String: Any]] = []
        if !systemPrompt.isEmpty {
            contents.append(["role": "user",  "parts": [["text": systemPrompt]]])
            contents.append(["role": "model", "parts": [["text": "Understood. I will follow these instructions."]]])
        }
        for msg in history.suffix(8) {
            contents.append(["role": msg.role == .user ? "user" : "model", "parts": [["text": msg.content]]])
        }
        contents.append(["role": "user", "parts": [["text": newMessage]]])
        return try await call(body: ["contents": contents, "generationConfig": ["temperature": 0.7, "maxOutputTokens": 1500]])
    }


    private func call(body: [String: Any]) async throws -> String {
        var req = URLRequest(url: config.geminiURL)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONSerialization.data(withJSONObject: body)
        let (data, response) = try await URLSession.shared.data(for: req)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw AIAssistantError.geminiError("HTTP \((response as? HTTPURLResponse)?.statusCode ?? -1): \(String(data: data, encoding: .utf8) ?? "")")
        }
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let text = ((json["candidates"] as? [[String: Any]])?.first?["content"] as? [String: Any])?["parts"]
                           .flatMap({ ($0 as? [[String: Any]])?.first?["text"] as? String }) else {
            throw AIAssistantError.geminiError("Could not parse Gemini response")
        }
        return text
    }
}
