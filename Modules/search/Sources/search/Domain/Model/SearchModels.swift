import Foundation

public struct SearchProductVariant: Identifiable {
    public let id: String
    public let title: String
    public let availableForSale: Bool
    public let quantityAvailable: Int?
    public let price: String
    public let currencyCode: String
    
    public init(id: String, title: String, availableForSale: Bool, quantityAvailable: Int?, price: String, currencyCode: String) {
        self.id = id
        self.title = title
        self.availableForSale = availableForSale
        self.quantityAvailable = quantityAvailable
        self.price = price
        self.currencyCode = currencyCode
    }
}

public struct SearchProduct: Identifiable {
    public let id: String
    public let title: String
    public let vendor: String
    public let price: String
    public let currencyCode: String
    public let imageUrl: URL?
    
    public var availableForSale: Bool
    public var variants: [SearchProductVariant]
    
    public init(id: String, title: String, vendor: String, price: String, currencyCode: String, imageUrl: URL?, availableForSale: Bool = true, variants: [SearchProductVariant] = []) {
        self.id = id
        self.title = title
        self.vendor = vendor
        self.price = price
        self.currencyCode = currencyCode
        self.imageUrl = imageUrl
        self.availableForSale = availableForSale
        self.variants = variants
    }
}

public struct SearchCollection: Identifiable {
    public let id: String
    public let title: String
    public let handle: String
    public let imageUrl: URL?
    
    public init(id: String, title: String, handle: String, imageUrl: URL?) {
        self.id = id
        self.title = title
        self.handle = handle
        self.imageUrl = imageUrl
    }
}

public struct PageInfo {
    public let hasNextPage: Bool
    public let endCursor: String?
    
    public init(hasNextPage: Bool, endCursor: String?) {
        self.hasNextPage = hasNextPage
        self.endCursor = endCursor
    }
}
