//
//  AddressRoute.swift
//  Address
//
//  Created by Mina Nashaat on 05/07/2026.
//

import Foundation

public enum AddressRoute: Hashable {
    case list
    case addOrEdit(editing: Address?)
}
