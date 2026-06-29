//
//  ShopifyApp.swift
//  Shopify
//
//  Created by Ahmed Elkady on 27/06/2026.
//

import SwiftUI
import ProductDetails

@main
struct ShopifyApp: App {
    var body: some Scene {
        WindowGroup {
            ProductDetailFactory.makeView(productId: 10390919708989)
        }
    }
}
