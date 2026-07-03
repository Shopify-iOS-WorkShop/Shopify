//
//  GridItemEntity.swift
//  Common
//
//  Created by Mina on 02/07/2026.
//

import Foundation

public struct GridItemEntity: Identifiable {
    public let id: String
    public let name: String
    public let imageURL: URL?
    public let isDefaultImage: Bool
}
