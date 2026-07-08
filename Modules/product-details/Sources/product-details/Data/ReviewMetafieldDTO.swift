import Foundation

struct ReviewMetafieldsResponse: Decodable {
    let metafields: [ReviewMetafieldDTO]
}

struct ReviewMetafieldResponse: Decodable {
    let metafield: ReviewMetafieldDTO
}

struct ReviewMetafieldDTO: Decodable {
    let id: Int
    let namespace: String?
    let key: String?
    let value: String
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, namespace, key, value
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct ReviewMetafieldRequest: Encodable {
    let metafield: ReviewMetafieldPayload
}

struct ReviewMetafieldPayload: Encodable {
    let id: Int?
    let namespace: String?
    let key: String?
    let type: String?
    let value: String

    enum CodingKeys: String, CodingKey {
        case id, namespace, key, type, value
    }
}

struct ReviewValuePayload: Codable {
    let author: String?
    let rating: Int?
    let title: String?
    let body: String?
    let createdAt: String?
    let customerId: String?
    let firebaseUID: String?

    enum CodingKeys: String, CodingKey {
        case author, rating, title, body
        case createdAt = "created_at"
        case customerId = "customer_id"
        case firebaseUID = "firebase_uid"
    }
}
