//
//  File.swift
//  
//
//  Created by Mazen Amr on 03/07/2026.
//

import Foundation

public struct Address: Identifiable, Equatable {
    public let id: String
    public let title: String
    public let details: String
    public let recipientName: String
    public let mobileNumber: String
    public let city: String
    public let street: String

    public init(id: String = UUID().uuidString, title: String, details: String, recipientName: String = "", mobileNumber: String = "", city: String = "", street: String = "") {
        self.id = id
        self.title = title
        self.details = details
        self.recipientName = recipientName
        self.mobileNumber = mobileNumber
        self.city = city
        self.street = street
    }
}
