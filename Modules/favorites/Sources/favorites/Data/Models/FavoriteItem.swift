import Foundation
import SwiftData


@Model
public final class FavoriteItem {
    @Attribute(.unique) public var productId: String
    public var title: String
    public var vendor: String
    public var price: Double
    public var rating: Double
    public var imageURL: String?
    public var productType: String
    public var isInStock: Bool
    public var savedAt: Date

    public init(
        productId: String,
        title: String,
        vendor: String,
        price: Double,
        rating: Double,
        imageURL: String?,
        productType: String,
        isInStock: Bool,
        savedAt: Date = .now
    ) {
        self.productId = productId
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
