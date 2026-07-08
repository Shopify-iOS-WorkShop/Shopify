import Foundation

public enum SearchRoute: Hashable {
    case productDetail(productId: Int)
    case productListing(collectionId: String, title: String)
}
