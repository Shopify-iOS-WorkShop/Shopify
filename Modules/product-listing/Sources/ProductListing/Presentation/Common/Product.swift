//
//  File.swift
//  
//
//  Created by Mazen Amr on 29/06/2026.
//

import Foundation
public struct Product: Identifiable {
    public let id: String
    public let title: String
    public let vendor: String
    public let price: Double
    public let rating: Double
    public let imageURL: URL?

    public init(id: String, title: String, vendor: String, price: Double, rating: Double, imageURL: URL?) {
        self.id = id
        self.title = title
        self.vendor = vendor
        self.price = price
        self.rating = rating
        self.imageURL = imageURL
    }
}
