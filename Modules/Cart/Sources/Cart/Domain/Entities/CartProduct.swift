import Foundation

public struct CartProduct: Equatable, Codable, Sendable {
    public let id: String
    public let title: String
    public let vendor: String?
    public let imageURL: URL?

    public init(
        id: String,
        title: String,
        vendor: String? = nil,
        imageURL: URL? = nil
    ) {
        self.id = id
        self.title = title
        self.vendor = vendor
        self.imageURL = imageURL
    }
}
