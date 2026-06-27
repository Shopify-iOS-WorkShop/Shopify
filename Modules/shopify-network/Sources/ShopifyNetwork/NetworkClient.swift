//
//  NetworkClient.swift
//  Shopify
//
//  Created by Mazen Amr on 27/06/2026.
//

import Foundation
public protocol NetworkClient {
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T
}

public class URLSessionNetworkClient: NetworkClient {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        guard let request = endpoint.urlRequest else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}
