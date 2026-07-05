//
//  ExchangeRateDTO.swift
//  Settings — Data
//

import Foundation

struct ExchangeRateResponseDTO: Decodable {
    let result: String
    let baseCode: String
    let rates: [String: Double]

    enum CodingKeys: String, CodingKey {
        case result
        case baseCode = "base_code"
        case rates
    }
}

extension ExchangeRateResponseDTO {
    func toDomain() -> ExchangeRates {
        ExchangeRates(baseCurrency: baseCode, rates: rates)
    }
}
