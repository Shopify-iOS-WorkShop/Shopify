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
import Payment
import Settings
import Favorites
import search
import Cart

@Observable
public final class AppCoordinator {
    public var hasCompletedAuth: Bool = false
    public var isShowingCheckout: Bool = false

    public var showGuestSignInPrompt: Bool = false

    public var authCoordinator = AuthCoordinator()
    public var homeCoordinator = HomeCoordinator()
    public var productListingCoordinator = ProductListingCoordinator()
    public var checkoutAddressCoordinator = CheckoutAddressCoordinator()
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
        cartCoordinator.onCheckoutRequested = { [weak self] cart in
                    guard let self = self else { return }
                    
                    let paymentItems = cart.lines.map { line in
                        Payment.CartItem(variantId: line.variantId, quantity: line.quantity)
                    }
                    
                    self.checkoutAddressCoordinator.cartItems = paymentItems
                    self.checkoutAddressCoordinator.totalAmount = Double(truncating: cart.cost.totalAmount.amount as NSNumber)
                    self.checkoutAddressCoordinator.deliveryFee = 15.0
                    
                    self.isShowingCheckout = true
                }

                cartCoordinator.onProductDetailRequested = { [weak self] productId, handle in
                    let idString = productId.components(separatedBy: "/").last ?? productId
                    if let idInt = Int(idString) {
                        self?.homeCoordinator.push(.productDetail(productId: idInt))
                    }
                }

                cartCoordinator.onSignInRequired = { [weak self] in
                    self?.hasCompletedAuth = false
                }
                
                checkoutAddressCoordinator.onCheckoutComplete = { [weak self] in
                    self?.isShowingCheckout = false
                    self?.checkoutAddressCoordinator.popToRoot()
                }

                searchCoordinator.onNavigateToDetail = { [weak self] productId in
                    self?.homeCoordinator.push(.productDetail(productId: productId))
                }

                searchCoordinator.onNavigateToListing = { [weak self] collectionId, title in
                    self?.homeCoordinator.push(.productListing(collectionId: collectionId, title: title))
                }
        }
    
}
