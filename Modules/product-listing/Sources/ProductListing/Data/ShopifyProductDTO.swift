//
//  File.swift
//  
//
//  Created by Mazen Amr on 01/07/2026.
//

import Foundation

struct ShopifyProductDTO: Decodable {
    let id: Int
    let title: String
    let vendor: String
    let product_type: String?
    let variants: [VariantDTO]?
    let image: ImageDTO?
    
    struct VariantDTO: Decodable {
        let price: String
        let inventory_quantity: Int?
    }
    
    struct ImageDTO: Decodable {
        let src: String
    }
    
    func toDomain() -> Product {
        let inStock = variants?.contains { ($0.inventory_quantity ?? 0) > 0 } ?? false
        
        return Product(
            id: String(id),
            title: title,
            vendor: vendor,
            price: Double(variants?.first?.price ?? "0.0") ?? 0.0,
            rating: 4.5,
            imageURL: URL(string: image?.src ?? ""),
            productType: product_type ?? "",
            isInStock: inStock
        )
    }
}
