//
//  File.swift
//  
//
//  Created by Mazen Amr on 28/06/2026.
//

import Foundation

struct SmartCollectionResponse: Decodable {
    let smart_collections: [CollectionDTO]
}

struct CustomCollectionResponse: Decodable {
    let custom_collections: [CollectionDTO]
}

struct CollectionDTO: Decodable {
    let id: Int
    let title: String
    let image: ImageDTO?
    
    struct ImageDTO: Decodable {
        let src: String
    }
    
    func toBrand() -> Brand {
        return Brand(
            id: String(id),
            title: title,
            imageURL: URL(string: image?.src ?? "")
        )
    }
    
    func toCategory() -> Category {
        let icon: String
        
        switch title.uppercased() {
        case "MEN":
            icon = "figure.stand"
        case "WOMEN":
            icon = "person.fill"
        case "KID":
            icon = "figure.and.child.holdinghands"
        case "SALE":
            icon = "tag.fill"
        case "HOME PAGE":
            icon = "house.fill"
        default:
            icon = "square.grid.2x2.fill"
        }
        
        return Category(
            id: String(id),
            title: title,
            iconName: icon
        )
    }
}
