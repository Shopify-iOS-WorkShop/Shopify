import Foundation



enum ProductDetailMapper {



    static func map(_ product: Product) -> ProductDetailEntity {

        // Safe extraction of unique sizes from values array where name matches "Size"

        let sizes = (product.options ?? [])

            .first(where: { $0.name.lowercased() == "size" })?

            .values ?? []



        let reviews = mockReviews()



        return ProductDetailEntity(

            id: product.id,

            title: product.title,

            collection: product.vendor ?? "Unknown Vendor",

            description: product.bodyHTML?.stripHTML() ?? "",

            price: Double((product.variants ?? []).first?.price ?? "0") ?? 0.0,

            rating: 4.5,

            reviewCount: 30,

            images: (product.images ?? []).map(\.src),

            sizes: sizes.isEmpty ? ["OS"] : sizes,

            reviews: reviews,

            isFavorite: false

        )

    }



    private static func mockReviews() -> [ReviewEntity] {

        [

            ReviewEntity(

                id: "1",

                authorInitials: "AD",

                authorName: "Verified Buyer",

                rating: 5,

                body: "Awesome classic backpack structure. Fits everything cleanly."

            )

        ]

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
