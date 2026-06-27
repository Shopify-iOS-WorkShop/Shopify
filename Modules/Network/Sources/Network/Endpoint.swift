//
//  Endpoint.swift
//
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
        var components = URLComponents(string: baseURL + path)
        components?.queryItems = queryItems
        
        guard let url = components?.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        return request
    }
}

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed(Error)
    case requestFailed(Error)
}
