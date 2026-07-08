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
        if config.provider == .groq {
            return try await callGroq(
                model: config.groqModel,
                messages: [["role": "user", "content": prompt]],
                maxTokens: 1024
            )
        }

        return try await callGemini(body: [
            "contents": [["parts": [["text": prompt]]]],
            "generationConfig": ["temperature": 0.7, "maxOutputTokens": 1024]
        ])
    }


    public func generate(prompt: String, imageData: Data, mimeType: String = "image/jpeg") async throws -> String {
        if config.provider == .groq {
            return try await callGroq(
                model: config.groqVisionModel,
                messages: [[
                    "role": "user",
                    "content": [
                        ["type": "text", "text": prompt],
                        [
                            "type": "image_url",
                            "image_url": [
                                "url": "data:\(mimeType);base64,\(imageData.base64EncodedString())"
                            ]
                        ]
                    ]
                ]],
                maxTokens: 1024
            )
        }

        return try await callGemini(body: [
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
        if config.provider == .groq {
            var messages: [[String: Any]] = []
            if !systemPrompt.isEmpty {
                messages.append(["role": "system", "content": systemPrompt])
            }
            for msg in history.suffix(8) {
                messages.append([
                    "role": groqRole(for: msg.role),
                    "content": msg.content
                ])
            }
            messages.append(["role": "user", "content": newMessage])
            return try await callGroq(model: config.groqModel, messages: messages, maxTokens: 1500)
        }

        var contents: [[String: Any]] = []
        if !systemPrompt.isEmpty {
            contents.append(["role": "user",  "parts": [["text": systemPrompt]]])
            contents.append(["role": "model", "parts": [["text": "Understood. I will follow these instructions."]]])
        }
        for msg in history.suffix(8) {
            contents.append(["role": msg.role == .user ? "user" : "model", "parts": [["text": msg.content]]])
        }
        contents.append(["role": "user", "parts": [["text": newMessage]]])
        return try await callGemini(body: ["contents": contents, "generationConfig": ["temperature": 0.7, "maxOutputTokens": 1500]])
    }


    private func callGemini(body: [String: Any]) async throws -> String {
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

    private func callGroq(model: String, messages: [[String: Any]], maxTokens: Int) async throws -> String {
        guard !config.groqAPIKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AIAssistantError.geminiError("Groq API key is not configured.")
        }

        var req = URLRequest(url: config.groqChatCompletionsURL)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("Bearer \(config.groqAPIKey)", forHTTPHeaderField: "Authorization")
        req.httpBody = try JSONSerialization.data(withJSONObject: [
            "model": model,
            "messages": messages,
            "temperature": 0.7,
            "max_completion_tokens": maxTokens
        ])

        let (data, response) = try await URLSession.shared.data(for: req)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw AIAssistantError.geminiError("Groq HTTP \((response as? HTTPURLResponse)?.statusCode ?? -1): \(String(data: data, encoding: .utf8) ?? "")")
        }
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let choices = json["choices"] as? [[String: Any]],
              let message = choices.first?["message"] as? [String: Any],
              let content = message["content"] as? String else {
            throw AIAssistantError.geminiError("Could not parse Groq response")
        }
        return content
    }

    private func groqRole(for role: MessageRole) -> String {
        switch role {
        case .user: return "user"
        case .assistant: return "assistant"
        case .system: return "system"
        }
    }
}
