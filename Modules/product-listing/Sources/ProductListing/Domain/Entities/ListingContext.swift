//
//  File.swift
//  
//
//  Created by Mazen Amr on 30/06/2026.
//

import Foundation

public enum ListingContext: Hashable {
    case allProducts
    case collection(id: String, title: String)
}
