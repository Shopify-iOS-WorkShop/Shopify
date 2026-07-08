//
//  File.swift
//  
//
//  Created by Mazen Amr on 03/07/2026.
//

import Foundation
import Common

public enum HomeRoute: Hashable {
    case productListing(collectionId: String?, title: String)
    case productDetail(productId: Int)
    case catalog(type: CatalogDisplayType)
}
