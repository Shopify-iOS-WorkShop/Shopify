//
//  File.swift
//  
//
//  Created by Mazen Amr on 27/06/2026.
//

import Foundation

public struct Category: Identifiable {
    public let id: String
    public let title: String
    public let iconName: String

    public init(id: String, title: String, iconName: String) {
        self.id = id
        self.title = title
        self.iconName = iconName
    }
}
