import Foundation

enum ProductDetailMapper {
    static func map(_ product: Product, reviews: [ReviewEntity] = []) -> ProductDetailEntity {
        let sizes = (product.options ?? [])
            .first(where: { $0.name.lowercased() == "size" })?
            .values ?? []

        let variants = (product.variants ?? []).map {
            ProductDetailVariantEntity(
                id: "gid://shopify/ProductVariant/\($0.id)",
                title: $0.title,
                quantityAvailable: $0.inventoryQuantity
            )
        }

        let averageRating = reviews.isEmpty
            ? 0
            : reviews.map(\.rating).reduce(0, +) / Double(reviews.count)

        return ProductDetailEntity(
            id: product.id,
            title: product.title,
            collection: product.vendor ?? "Unknown Vendor",
            description: product.bodyHTML?.stripHTML() ?? "",
            price: Double((product.variants ?? []).first?.price ?? "0") ?? 0.0,
            rating: averageRating,
            reviewCount: reviews.count,
            images: (product.images ?? []).map(\.src),
            sizes: sizes.isEmpty ? ["OS"] : sizes,
            variants: variants,
            reviews: reviews,
            isFavorite: false
        )
    }

    static func mapReviews(
        _ metafields: [ReviewMetafieldDTO],
        currentCustomerId: String?,
        currentFirebaseUID: String?,
        currentCustomerName: String?
    ) -> [ReviewEntity] {
        metafields.compactMap { metafield in
            guard let data = metafield.value.data(using: .utf8),
                  let value = try? JSONDecoder().decode(ReviewValuePayload.self, from: data),
                  let body = value.body?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !body.isEmpty else {
                return nil
            }

            let createdAt = parseDate(value.createdAt) ?? parseDate(metafield.createdAt)
            let author = value.author?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let storedAuthor = author.isEmpty ? "Verified Buyer" : author
            let isOwner = matchesOwner(
                reviewCustomerId: value.customerId,
                reviewFirebaseUID: value.firebaseUID,
                currentCustomerId: currentCustomerId,
                currentFirebaseUID: currentFirebaseUID
            )
            let ownerName = currentCustomerName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let shouldUseOwnerName = isOwner && !ownerName.isEmpty && (author.isEmpty || author == "Verified Buyer")
            let displayAuthor = shouldUseOwnerName ? ownerName : storedAuthor

            return ReviewEntity(
                id: String(metafield.id),
                metafieldId: metafield.id,
                authorInitials: initials(from: displayAuthor),
                authorName: displayAuthor,
                rating: Double(value.rating ?? 0),
                title: value.title?.isEmpty == false ? value.title : nil,
                body: body,
                createdAt: createdAt,
                ownerCustomerId: value.customerId,
                ownerFirebaseUID: value.firebaseUID,
                isOwnedByCurrentCustomer: isOwner
            )
        }
        .sorted { lhs, rhs in
            (lhs.createdAt ?? .distantPast) > (rhs.createdAt ?? .distantPast)
        }
    }

    private static func matchesOwner(
        reviewCustomerId: String?,
        reviewFirebaseUID: String?,
        currentCustomerId: String?,
        currentFirebaseUID: String?
    ) -> Bool {
        if let reviewCustomerId, let currentCustomerId, reviewCustomerId == currentCustomerId {
            return true
        }
        if let reviewFirebaseUID, let currentFirebaseUID, reviewFirebaseUID == currentFirebaseUID {
            return true
        }
        return false
    }

    private static func initials(from name: String) -> String {
        let initials = name
            .split(separator: " ")
            .prefix(2)
            .compactMap(\.first)
        let value = String(initials).uppercased()
        return value.isEmpty ? "VB" : value
    }

    private static func parseDate(_ rawValue: String?) -> Date? {
        guard let rawValue else { return nil }
        if let date = ISO8601DateFormatter().date(from: rawValue) {
            return date
        }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: rawValue)
    }
}

private extension String {
    func stripHTML() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        return (try? NSAttributedString(data: data, options: options, documentAttributes: nil))?.string ?? self
    }
}
