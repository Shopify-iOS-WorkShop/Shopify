//
//  AppCoordinator.swift
//  Shopify
//
//  Created by Mazen Amr on 03/07/2026.
//

import Foundation
import SwiftUI
import Observation
import Auth
import Home
import ProductListing
import Settings
import Favorites
import search
import Cart

@Observable
public final class AppCoordinator {
    public var hasCompletedAuth: Bool = false

    public var showGuestSignInPrompt: Bool = false

    public var authCoordinator = AuthCoordinator()
    public var homeCoordinator = HomeCoordinator()
    public var productListingCoordinator = ProductListingCoordinator()
    public var settingsCoordinator = SettingsCoordinator()
    public var favoritesCoordinator = FavoritesCoordinator()
    public var searchCoordinator = SearchCoordinator()
    public var cartCoordinator = CartCoordinator()

    public init() {
        setupCallbacks()
    }

    private func setupCallbacks() {
        authCoordinator.onLoginSuccess = { [weak self] in
            self?.hasCompletedAuth = true
        }

        authCoordinator.onContinueAsGuest = { [weak self] in
            self?.hasCompletedAuth = true
        }

        favoritesCoordinator.onNavigateToDetail = { [weak self] productId in
            self?.homeCoordinator.push(.productDetail(productId: productId))
        }

        searchCoordinator.onNavigateToDetail = { [weak self] productId in
            self?.homeCoordinator.push(.productDetail(productId: productId))
        }

        searchCoordinator.onNavigateToListing = { [weak self] collectionId, title in
            self?.homeCoordinator.push(.productListing(collectionId: collectionId, title: title))
        }
    }
}
