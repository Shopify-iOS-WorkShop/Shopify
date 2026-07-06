//
//  File.swift
//  
//
//  Created by Mazen Amr on 04/07/2026.
//

import Foundation

public struct OrderInfo {
    public let id: String
    public let orderNumber: String
    
    public init(id: String, orderNumber: String) {
        self.id = id
        self.orderNumber = orderNumber
    }
}
