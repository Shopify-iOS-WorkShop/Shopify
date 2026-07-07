//
//  Endpoint.swift
//  Shopify
//
//  Created by Mazen Amr on 27/06/2026.
//

import Foundation

public protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: String { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
}

public extension Endpoint {
    var urlRequest: URLRequest? {
        let fullURLString = baseURL + path
        guard let encodedString = fullURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedString) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        return request
    }
}

public enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case decodingFailed(Error)
    case requestFailed(Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL constructed. Check for hidden spaces in your endpoints."
        case .invalidResponse(let statusCode):
            return "Server returned an invalid response (Status Code: \(statusCode)). Check API keys."
        case .decodingFailed(let error):
            return "Failed to decode Shopify JSON: \(error.localizedDescription)"
        case .requestFailed(let error):
            return "Network request failed: \(error.localizedDescription)"
        }
    }
}
