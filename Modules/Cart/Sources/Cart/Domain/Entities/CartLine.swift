import Foundation
import Common

public struct CartLine: Equatable, Identifiable {
    public let id: String
    public let quantity: Int
    public let variantId: String
    public let variantTitle: String
    public let productId: String
    public let productTitle: String
    public let productHandle: String
    public let vendor: String
    public let imageURL: URL?
    public let price: Money
    public let compareAtPrice: Money?
    public let subtotalAmount: Money
    public let totalAmount: Money
    public let totalDiscountedAmount: Money
    public let selectedOptions: [ProductOption]
    public let availableForSale: Bool
    public let quantityAvailable: Int?

    public init(
        id: String,
        quantity: Int,
        variantId: String,
        variantTitle: String,
        productId: String,
        productTitle: String,
        productHandle: String,
        vendor: String,
        imageURL: URL?,
        price: Money,
        compareAtPrice: Money?,
        subtotalAmount: Money,
        totalAmount: Money,
        totalDiscountedAmount: Money,
        selectedOptions: [ProductOption],
        availableForSale: Bool,
        quantityAvailable: Int?
    ) {
        self.id = id
        self.quantity = quantity
        self.variantId = variantId
        self.variantTitle = variantTitle
        self.productId = productId
        self.productTitle = productTitle
        self.productHandle = productHandle
        self.vendor = vendor
        self.imageURL = imageURL
        self.price = price
        self.compareAtPrice = compareAtPrice
        self.subtotalAmount = subtotalAmount
        self.totalAmount = totalAmount
        self.totalDiscountedAmount = totalDiscountedAmount
        self.selectedOptions = selectedOptions
        self.availableForSale = availableForSale
        self.quantityAvailable = quantityAvailable
    }
}

public struct ProductOption: Equatable {
    public let name: String
    public let value: String

    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}
