import Foundation


public struct FavoriteProduct: Identifiable, Equatable {
    public let id: String
    public let title: String
    public let vendor: String
    public let price: Double
    public let rating: Double
    public let imageURL: URL?
    public let productType: String
    public let isInStock: Bool
    public let savedAt: Date

    public init(
        id: String,
        title: String,
        vendor: String,
        price: Double,
        rating: Double,
        imageURL: URL?,
        productType: String,
        isInStock: Bool,
        savedAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.vendor = vendor
        self.price = price
        self.rating = rating
        self.imageURL = imageURL
        self.productType = productType
        self.isInStock = isInStock
        self.savedAt = savedAt
    }
}
