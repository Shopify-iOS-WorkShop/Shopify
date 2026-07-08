//
//  SettingsRoute.swift
//  Settings — Presentation
//

import Foundation

public enum SettingsRoute: Hashable {
    case addresses
    case orderHistory
    case currencyPicker
    case orderDetail(order: CustomerOrder)
}
