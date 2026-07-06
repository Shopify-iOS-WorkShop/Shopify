//
//  File.swift
//  
//
//  Created by Mazen Amr on 05/07/2026.
//

import Foundation

final class StripeChargeService {
    static let shared = StripeChargeService()
    private let endpoint = URL(string: "https://stripe-payment-intent-nu.vercel.app/api/create-payment-intent")!

    private struct PaymentRequestBody: Encodable {
        let amount: Double
        let currency: String
    }
    
    func fetchClientSecret(amount: Double, currency: String = "usd") async throws -> String {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = PaymentRequestBody(amount: amount, currency: currency)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "PaymentError", code: 5,
                           userInfo: [NSLocalizedDescriptionKey: "Failed to create payment intent."])
        }
        
        struct Result: Decodable { let clientSecret: String }
        let decoded = try JSONDecoder().decode(Result.self, from: data)
        return decoded.clientSecret
    }
}
