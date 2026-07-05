//
//  File.swift
//  
//
//  Created by Mazen Amr on 03/07/2026.
//

import Foundation
public enum Tab: String, CaseIterable {
    case home = "Home"
    case search = "Search"
    case cart = "Cart"
    case wishlist = "Wishlist"
    case account = "Account"
    
    var icon: String {
        switch self {
        case .home: return "house"
        case .search: return "magnifyingglass"
        case .cart: return "cart"
        case .wishlist: return "heart"
        case .account: return "person"
        }
    }
    
    var activeIcon: String {
        switch self {
        case .home: return "house.fill"
        case .search: return "magnifyingglass"
        case .cart: return "cart.fill"
        case .wishlist: return "heart.fill"
        case .account: return "person.fill"
        }
    }
}
