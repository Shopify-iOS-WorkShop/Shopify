import Foundation



public struct ProductResponse: Codable {

    public let products: [Product]?

    public let product: Product?

    public let variants: [Variant]?

    public let customCollections: [Collection]?

    public let smartCollections: [Collection]?



    enum CodingKeys: String, CodingKey {

        case products, product, variants

        case customCollections = "custom_collections"

        case smartCollections = "smart_collections"

    }

}



public struct Product: Codable {

    public let id: Int

    public let title: String

    public let bodyHTML: String?

    public let vendor: String?

    public let productType: String?

    public let status: String?

    public let tags: String?

    public let variants: [Variant]?

    public let options: [Option]?

    public let images: [ProductImage]?

    public let image: ProductImage?



    enum CodingKeys: String, CodingKey {

        case id, title, vendor, status, tags, variants, options, images, image

        case bodyHTML = "body_html"

        case productType = "product_type"

    }

}



public struct Variant: Codable {

    public let id: Int

    public let productID: Int

    public let title: String

    public let price: String

    public let inventoryQuantity: Int?



    enum CodingKeys: String, CodingKey {

        case id, title, price

        case productID = "product_id"

        case inventoryQuantity = "inventory_quantity"

    }

}



public struct Option: Codable {

    public let id: Int

    public let name: String

    public let values: [String]

}



public struct ProductImage: Codable {

    public let id: Int

    public let src: String

    public let alt: String?

}



public struct Collection: Codable {

    public let id: Int

    public let title: String

    public let bodyHTML: String?

    public let image: ProductImage?



    enum CodingKeys: String, CodingKey {

        case id, title, image

        case bodyHTML = "body_html"

    }

}
