//
//  File.swift
//  
//
//  Created by Mazen Amr on 07/07/2026.
//

import Foundation

struct RESTOrderResponse: Decodable {
    let order: RESTOrderResponseData
}

struct RESTOrderResponseData: Decodable {
    let id: Int
    let name: String
}
