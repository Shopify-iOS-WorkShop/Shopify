//
//  CartMapper.swift
//  Cart
//

import Foundation

public struct CartMapper {
    public static func map(dto: DraftOrderDTO) -> Cart? {
        let cartID = CartID(rawValue: String(dto.id))
        
        var mappedLines: [CartLineItem] = []
        for lineDTO in dto.lineItems {
            // Shopify Draft Orders API sometimes returns an empty dummy line if the order is empty,
            // we should ignore lines that don't have valid product data.
            guard let variantIdInt = lineDTO.variantId,
                  let productIdInt = lineDTO.productId,
                  let priceString = lineDTO.price,
                  let price = Decimal(string: priceString),
                  let lineIdInt = lineDTO.id else {
                continue
            }
            
            let quantity = try? LineItemQuantity(lineDTO.quantity)
            
            // Extract image URL from properties if available
            var imageURL: URL? = nil
            if let properties = lineDTO.properties {
                if let urlString = properties.first(where: { $0.name == "image_url" })?.value {
                    imageURL = URL(string: urlString)
                }
            }
            
            let product = CartProduct(
                variantID: ProductVariantID(rawValue: String(variantIdInt)),
                productID: String(productIdInt),
                title: lineDTO.title ?? "Unknown Product",
                imageURL: imageURL
            )
            
            let lineItem = CartLineItem(
                id: CartLineItemID(rawValue: String(lineIdInt)),
                product: product,
                quantity: quantity ?? (try! LineItemQuantity(1)),
                price: Money(amount: price, currencyCode: dto.currency ?? "USD")
            )
            
            mappedLines.append(lineItem)
        }
        
        let subtotal = Decimal(string: dto.subtotalPrice ?? "0") ?? 0
        let tax = Decimal(string: dto.totalTax ?? "0") ?? 0
        let total = Decimal(string: dto.totalPrice ?? "0") ?? 0
        let currency = dto.currency ?? "USD"
        
        let totals = CartTotals(
            subtotal: Money(amount: subtotal, currencyCode: currency),
            tax: Money(amount: tax, currencyCode: currency),
            total: Money(amount: total, currencyCode: currency)
        )
        
        return Cart(id: cartID, lines: mappedLines, totals: totals)
    }
}
