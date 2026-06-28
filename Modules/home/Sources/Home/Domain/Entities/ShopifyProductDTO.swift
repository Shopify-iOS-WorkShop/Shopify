//
//  File.swift
//  
//
//  Created by Mazen Amr on 28/06/2026.
//

import Foundation

struct ShopifyProductResponse: Decodable {
    let products: [ShopifyProductDTO]
}

struct ShopifyProductDTO: Decodable {
    let id: Int
    let title: String
    let vendor: String
    let variants: [VariantDTO]?
    let image: ImageDTO?
    
    struct VariantDTO: Decodable {
        let price: String
    }
    
    struct ImageDTO: Decodable {
        let src: String
    }
    
   
    func toDomain() -> Product {
        return Product(
            id: String(id),
            title: title,
            vendor: vendor,
            price: Double(variants?.first?.price ?? "0.0") ?? 0.0,
            rating: 4.5,
            imageURL: URL(string: image?.src ?? "")
        )
    }
}
