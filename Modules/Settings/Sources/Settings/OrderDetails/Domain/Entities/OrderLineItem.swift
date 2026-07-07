//
//  File.swift
//  
//
//  Created by Mazen Amr on 07/07/2026.
//

import Foundation

public struct OrderLineItem: Equatable, Identifiable {
    public let id: String
    public let title: String
    public let variantTitle: String?
    public let quantity: Int
    public let price: Double
    public let imageURL: URL?

    public init(
        id: String,
        title: String,
        variantTitle: String?,
        quantity: Int,
        price: Double,
        imageURL: URL?
    ) {
        self.id = id
        self.title = title
        self.variantTitle = variantTitle
        self.quantity = quantity
        self.price = price
        self.imageURL = imageURL
    }
}
