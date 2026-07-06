//
//  ExchangeRateDataSource.swift
//  Settings — Data
//

import Foundation
import ShopifyNetwork

final class ExchangeRateDataSource {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = URLSessionNetworkClient()) {
        self.networkClient = networkClient
    }

    func fetchRates(base: String) async throws -> ExchangeRates {
        let endpoint = ExchangeRateEndpoint(baseCurrency: base)
        do {
            let dto: ExchangeRateResponseDTO = try await networkClient.request(endpoint: endpoint)
            return dto.toDomain()
        } catch let networkError as NetworkError {
            switch networkError {
            case .decodingFailed:
                throw SettingsError.decodingError
            default:
                throw SettingsError.networkError(networkError.localizedDescription)
            }
        }
    }
}

private struct ExchangeRateEndpoint: Endpoint {
    let baseCurrency: String

    var baseURL: String { "https://open.er-api.com" }
    var path: String { "/v6/latest/\(baseCurrency)" }
    var method: String { "GET" }
    var headers: [String: String]? { nil }
    var queryItems: [URLQueryItem]? { nil }
    var body: Data? { nil }
}
