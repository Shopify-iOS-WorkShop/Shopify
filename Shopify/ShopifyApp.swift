//
//  ShopifyApp.swift
//  Shopify
//
//  Created by Ahmed Elkady on 27/06/2026.
//

import SwiftUI
import Home
import ShopifyNetwork
import ProductListing
@main
struct ShopifyApp: App {
    var body: some Scene {
        WindowGroup {
            let client = URLSessionNetworkClient()
            let repo = HomeRepository(networkClient: client)
            let viewModel = HomeViewModel(repository: repo)
            NavigationStack {
                ProductListingView(title: "Women's Tops")
            }
        }
    }
}
