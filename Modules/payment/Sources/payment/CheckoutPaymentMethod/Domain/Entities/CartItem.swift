//
//  File.swift
//  
//
//  Created by Mazen Amr on 07/07/2026.
//

import Foundation

public struct CartItem {
    public let variantId: String
    public let quantity: Int
 
    public init(variantId: String, quantity: Int) {
        self.variantId = variantId
        self.quantity = quantity
    }
}

