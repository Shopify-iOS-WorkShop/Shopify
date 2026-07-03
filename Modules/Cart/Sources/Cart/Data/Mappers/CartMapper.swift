import Foundation
import Common

internal enum CartMapper {
    static func toDTO(from fragment: CartFragment) -> CartResponseDTO {
        let lines: [CartLineDTO] = fragment.lines.nodes.compactMap { node in
            guard let variant = node.merchandise.asProductVariant else { return nil }
            
            let selectedOptions = variant.selectedOptions.map { ($0.name, $0.value) }
            
            // Assuming discountAllocations exist in CartLineFragment
            var totalDiscountedAmount: MoneyDTO = MoneyDTO(amount: "0", currencyCode: fragment.cost.totalAmount.currencyCode)
            if let allocations = node.discountAllocations {
                for allocation in allocations {
                    let amount = allocation.discountedAmount
                    // Simplification: In a real app we might sum them accurately if they are in same currency
                    // Here we just take the last or sum if needed. We will just map it simply.
                    totalDiscountedAmount = MoneyDTO(amount: amount.amount, currencyCode: amount.currencyCode)
                }
            }

            return CartLineDTO(
                id: node.id,
                quantity: node.quantity,
                variantId: variant.id,
                variantTitle: variant.title,
                productId: variant.product.id,
                productTitle: variant.product.title,
                productHandle: variant.product.handle,
                vendor: variant.product.vendor,
                imageURL: variant.image?.url,
                price: MoneyDTO(amount: variant.price.amount, currencyCode: variant.price.currencyCode),
                compareAtPrice: variant.compareAtPrice.map { MoneyDTO(amount: $0.amount, currencyCode: $0.currencyCode) },
                subtotalAmount: MoneyDTO(amount: node.cost.subtotalAmount.amount, currencyCode: node.cost.subtotalAmount.currencyCode),
                totalAmount: MoneyDTO(amount: node.cost.totalAmount.amount, currencyCode: node.cost.totalAmount.currencyCode),
                totalDiscountedAmount: totalDiscountedAmount,
                selectedOptions: selectedOptions,
                availableForSale: variant.availableForSale,
                quantityAvailable: variant.quantityAvailable
            )
        }
        
        let discountCodes = fragment.discountCodes.map { 
            CartDiscountDTO(code: $0.code, applicable: $0.applicable) 
        }

        return CartResponseDTO(
            id: fragment.id,
            checkoutUrl: fragment.checkoutUrl,
            totalQuantity: fragment.totalQuantity,
            note: fragment.note,
            lines: lines,
            subtotalAmount: MoneyDTO(amount: fragment.cost.subtotalAmount.amount, currencyCode: fragment.cost.subtotalAmount.currencyCode),
            totalAmount: MoneyDTO(amount: fragment.cost.totalAmount.amount, currencyCode: fragment.cost.totalAmount.currencyCode),
            checkoutChargeAmount: MoneyDTO(amount: fragment.cost.checkoutChargeAmount.amount, currencyCode: fragment.cost.checkoutChargeAmount.currencyCode),
            discountCodes: discountCodes
        )
    }

    static func toDomain(from dto: CartResponseDTO) -> Cart {
        let checkoutUrl = URL(string: dto.checkoutUrl) ?? URL(string: "https://shopify.com")!
        
        let domainLines = dto.lines.map { toCartLine(from: $0) }
        
        let cost = CartCost(
            subtotalAmount: toMoney(from: dto.subtotalAmount),
            totalAmount: toMoney(from: dto.totalAmount),
            checkoutChargeAmount: toMoney(from: dto.checkoutChargeAmount)
        )
        
        let discounts = dto.discountCodes.map { CartDiscount(code: $0.code, applicable: $0.applicable) }
        
        return Cart(
            id: dto.id,
            checkoutUrl: checkoutUrl,
            totalQuantity: dto.totalQuantity,
            note: dto.note,
            lines: domainLines,
            cost: cost,
            discountCodes: discounts
        )
    }

    static func toCartLine(from dto: CartLineDTO) -> CartLine {
        let options = dto.selectedOptions.map { ProductOption(name: $0.name, value: $0.value) }
        
        let imageURL = dto.imageURL.flatMap { URL(string: $0) }
        
        return CartLine(
            id: dto.id,
            quantity: dto.quantity,
            variantId: dto.variantId,
            variantTitle: dto.variantTitle,
            productId: dto.productId,
            productTitle: dto.productTitle,
            productHandle: dto.productHandle,
            vendor: dto.vendor,
            imageURL: imageURL,
            price: toMoney(from: dto.price),
            compareAtPrice: dto.compareAtPrice.map { toMoney(from: $0) },
            subtotalAmount: toMoney(from: dto.subtotalAmount),
            totalAmount: toMoney(from: dto.totalAmount),
            totalDiscountedAmount: toMoney(from: dto.totalDiscountedAmount),
            selectedOptions: options,
            availableForSale: dto.availableForSale,
            quantityAvailable: dto.quantityAvailable
        )
    }

    static func toMoney(from dto: MoneyDTO) -> Money {
        return Money(amountString: dto.amount, currencyCode: dto.currencyCode)
    }

    static func toCart(from apolloCart: CartFragment) -> Cart {
        let dto = toDTO(from: apolloCart)
        return toDomain(from: dto)
    }

    static func extractUserErrors(from errors: [any UserErrorProtocol]) -> AppError? {
        if errors.isEmpty { return nil }
        return AppError.graphQL(errors.map { $0.message })
    }
}

public protocol UserErrorProtocol {
    var message: String { get }
}

