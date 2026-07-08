import Foundation

import Common
import ShopifyNetwork



// 1. Create a local Sendable typealias interface wrapper

// to satisfy strict cross-actor isolation checks safely.

private struct SendableNetworkWrapper: @unchecked Sendable {

    let client: NetworkClient

    

    func request<T: Decodable>(endpoint: Endpoint) async throws -> T {

        try await client.request(endpoint: endpoint)

    }

}



@MainActor

public final class ProductDetailRepository: ProductDetailRepositoryProtocol, @unchecked Sendable {



    // 2. Hold the safe wrapper instead of the raw non-Sendable protocol instance directly

    private let networkWrapper: SendableNetworkWrapper
    private let sessionProvider: SessionProviding?



    public init(networkClient: NetworkClient, sessionProvider: SessionProviding? = nil) {

        self.networkWrapper = SendableNetworkWrapper(client: networkClient)
        self.sessionProvider = sessionProvider

    }



    public func fetchProduct(id: Int) async throws -> ProductDetailEntity {

        let endpoint = ShopifyProductEndpoint.getProduct(id: id)

        

        // 3. Make the request via the wrapper—clearing the data race warning instantly

        let response: ProductResponse = try await networkWrapper.request(endpoint: endpoint)

        

        guard let product = response.product else {

            throw NSError(

                domain: "ProductDetailRepository",

                code: 404,

                userInfo: [NSLocalizedDescriptionKey: "Product details not found in the response wrapper."]

            )

        }

        

        let reviews = try await fetchReviews(productId: id)

        return ProductDetailMapper.map(product, reviews: reviews)

    }

    public func createReview(productId: Int, input: ReviewInput) async throws -> ProductDetailEntity {
        guard isAuthenticated else { throw ProductReviewError.authenticationRequired }

        let payload = try  await makeCreateRequest(input: input)
        let endpoint = ReviewMetafieldEndpoint.createReview(productId: productId, payload: payload)
        let _: ReviewMetafieldResponse = try await networkWrapper.request(endpoint: endpoint)
        return try await fetchProduct(id: productId)
    }

    public func updateReview(productId: Int, review: ReviewEntity, input: ReviewInput) async throws -> ProductDetailEntity {
        guard isAuthenticated else { throw ProductReviewError.authenticationRequired }
        guard review.isOwnedByCurrentCustomer else { throw ProductReviewError.notReviewOwner }
        guard let metafieldId = review.metafieldId else { throw ProductReviewError.missingMetafieldId }

        let payload = try await makeUpdateRequest(review: review, input: input)
        let endpoint = ReviewMetafieldEndpoint.updateReview(metafieldId: metafieldId, payload: payload)
        let _: ReviewMetafieldResponse = try await networkWrapper.request(endpoint: endpoint)
        return try await fetchProduct(id: productId)
    }

    public func deleteReview(productId: Int, review: ReviewEntity) async throws -> ProductDetailEntity {
        guard isAuthenticated else { throw ProductReviewError.authenticationRequired }
        guard review.isOwnedByCurrentCustomer else { throw ProductReviewError.notReviewOwner }
        guard let metafieldId = review.metafieldId else { throw ProductReviewError.missingMetafieldId }

        try await performVoidRequest(endpoint: ReviewMetafieldEndpoint.deleteReview(metafieldId: metafieldId))
        return try await fetchProduct(id: productId)
    }

    private var isAuthenticated: Bool {
        sessionProvider?.isAuthenticated == true
    }

    private func fetchReviews(productId: Int) async throws -> [ReviewEntity] {
        let endpoint = ReviewMetafieldEndpoint.getReviews(productId: productId)
        let response: ReviewMetafieldsResponse = try await networkWrapper.request(endpoint: endpoint)
        let customerName = try? await currentCustomerFullName()
        return ProductDetailMapper.mapReviews(
            response.metafields,
            currentCustomerId: sessionProvider?.current?.customerId,
            currentFirebaseUID: sessionProvider?.current?.firebaseUID,
            currentCustomerName: customerName
        )
    }

    private func makeCreateRequest(input: ReviewInput) async throws -> ReviewMetafieldRequest {
        let value = try await makeReviewValue(input: input, createdAt: Date())
        return ReviewMetafieldRequest(
            metafield: ReviewMetafieldPayload(
                id: nil,
                namespace: "reviews",
                key: "review_\(Int(Date().timeIntervalSince1970))",
                type: "json",
                value: value
            )
        )
    }

    private func makeUpdateRequest(review: ReviewEntity, input: ReviewInput) async throws -> ReviewMetafieldRequest {
        let value = try await makeReviewValue(input: input, createdAt: review.createdAt ?? Date())
        return ReviewMetafieldRequest(
            metafield: ReviewMetafieldPayload(
                id: review.metafieldId,
                namespace: nil,
                key: nil,
                type: nil,
                value: value
            )
        )
    }

    private func makeReviewValue(input: ReviewInput, createdAt: Date) async throws -> String {
        let session = sessionProvider?.current
        let authorName = try await currentCustomerFullName() ?? "Verified Buyer"
        let payload = ReviewValuePayload(
            author: authorName,
            rating: max(1, min(5, input.rating)),
            title: input.title.trimmingCharacters(in: .whitespacesAndNewlines),
            body: input.body.trimmingCharacters(in: .whitespacesAndNewlines),
            createdAt: ISO8601DateFormatter().string(from: createdAt),
            customerId: session?.customerId,
            firebaseUID: session?.firebaseUID
        )
        let data = try JSONEncoder().encode(payload)
        guard let json = String(data: data, encoding: .utf8) else {
            throw ProductReviewError.invalidPayload
        }
        return json
    }

    private func currentCustomerFullName() async throws -> String? {
        guard let token = sessionProvider?.current?.customerAccessToken, !token.isEmpty else {
            return nil
        }
        let endpoint = ReviewCustomerProfileEndpoint(customerAccessToken: token)
        let response: ReviewCustomerProfileResponse = try await networkWrapper.request(endpoint: endpoint)
        return response.data?.customer?.fullName
    }

    private func performVoidRequest(endpoint: Endpoint) async throws {
        guard let request = endpoint.urlRequest else {
            throw NetworkError.invalidURL
        }
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0)
        }
    }

}

enum ProductReviewError: LocalizedError {
    case authenticationRequired
    case notReviewOwner
    case missingMetafieldId
    case invalidPayload

    var errorDescription: String? {
        switch self {
        case .authenticationRequired:
            return "Please sign in to manage product reviews."
        case .notReviewOwner:
            return "You can only edit or delete your own review."
        case .missingMetafieldId:
            return "This review cannot be changed because its Shopify metafield id is missing."
        case .invalidPayload:
            return "Review details could not be prepared."
        }
    }
}
