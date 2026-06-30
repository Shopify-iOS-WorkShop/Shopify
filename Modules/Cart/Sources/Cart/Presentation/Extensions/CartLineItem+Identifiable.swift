//
//  CartLineItem+Identifiable.swift
//  Cart
//

import Foundation

extension CartLineItem: Identifiable {
    // `id` already exists as CartLineID — expose as String for SwiftUI
    public var itemID: String { id.rawValue }
}
