//
//  File.swift
//  
//
//  Created by Mazen Amr on 27/06/2026.
//

import Foundation

public struct Brand: Identifiable {
    public let id: String
    public let title: String
    public let imageURL: URL?
    
    public init(id: String, title: String, imageURL: URL?) {
        self.id = id
        self.title = title
        self.imageURL = imageURL
    }
}
