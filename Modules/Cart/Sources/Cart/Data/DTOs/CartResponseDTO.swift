import Foundation

internal struct CartResponseDTO {
    let id: String
    let checkoutUrl: String
    let totalQuantity: Int
    let note: String?
    let lines: [CartLineDTO]
    let subtotalAmount: MoneyDTO
    let totalAmount: MoneyDTO
    let checkoutChargeAmount: MoneyDTO
    let discountCodes: [CartDiscountDTO]
}

internal struct CartLineDTO {
    let id: String
    let quantity: Int
    let variantId: String
    let variantTitle: String
    let productId: String
    let productTitle: String
    let productHandle: String
    let vendor: String
    let imageURL: String?
    let price: MoneyDTO
    let compareAtPrice: MoneyDTO?
    let subtotalAmount: MoneyDTO
    let totalAmount: MoneyDTO
    let totalDiscountedAmount: MoneyDTO
    let selectedOptions: [(name: String, value: String)]
    let availableForSale: Bool
    let quantityAvailable: Int?
}

internal struct MoneyDTO {
    let amount: String
    let currencyCode: String
}

internal struct CartDiscountDTO {
    let code: String
    let applicable: Bool
}
