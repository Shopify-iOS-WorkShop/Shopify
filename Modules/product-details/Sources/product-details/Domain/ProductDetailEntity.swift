import Foundation



public struct ProductDetailEntity {

    public let id: Int

    public let title: String

    public let collection: String

    public let description: String

    public let price: Double

    public let rating: Double

    public let reviewCount: Int

    public let images: [String]        // URLs

    public let sizes: [String]

    public let variants: [ProductDetailVariantEntity]

    public let reviews: [ReviewEntity]

    public let isFavorite: Bool



    public init(

        id: Int,

        title: String,

        collection: String,

        description: String,

        price: Double,

        rating: Double,

        reviewCount: Int,

        images: [String],

        sizes: [String],

        variants: [ProductDetailVariantEntity],

        reviews: [ReviewEntity],

        isFavorite: Bool = false

    ) {

        self.id = id

        self.title = title

        self.collection = collection

        self.description = description

        self.price = price

        self.rating = rating

        self.reviewCount = reviewCount

        self.images = images

        self.sizes = sizes

        self.variants = variants

        self.reviews = reviews

        self.isFavorite = isFavorite

    }

    public func variantId(for size: String?) -> String? {
        guard let size, !size.isEmpty else {
            return variants.first?.id
        }

        return variants.first { variant in
            let components = variant.title.components(separatedBy: " / ").map { $0.trimmingCharacters(in: .whitespaces) }
            return components.contains { $0.caseInsensitiveCompare(size) == .orderedSame }
        }?.id ?? variants.first?.id
    }
}

public struct ProductDetailVariantEntity {
    public let id: String
    public let title: String
    public let quantityAvailable: Int?

    public init(id: String, title: String, quantityAvailable: Int?) {
        self.id = id
        self.title = title
        self.quantityAvailable = quantityAvailable
    }
}



public struct ReviewEntity {

    public let id: String

    public let authorInitials: String

    public let authorName: String

    public let rating: Double

    public let body: String



    public init(id: String, authorInitials: String, authorName: String, rating: Double, body: String) {

        self.id = id

        self.authorInitials = authorInitials

        self.authorName = authorName

        self.rating = rating

        self.body = body

    }

}
