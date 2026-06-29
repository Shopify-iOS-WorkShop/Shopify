import XCTest
@testable import Cart

final class CartTests: XCTestCase {
    func testCartTotalQuantitySumsLineQuantities() {
        let cart = Cart(
            id: CartID(rawValue: "cart-id"),
            lines: [
                CartLineItem(
                    id: CartLineID(rawValue: "line-1"),
                    variantID: ProductVariantID(rawValue: "variant-1"),
                    product: CartProduct(id: "product-1", title: "Sneaker"),
                    quantity: 2,
                    unitPrice: Money(amount: 100, currencyCode: "EGP"),
                    totalPrice: Money(amount: 200, currencyCode: "EGP")
                ),
                CartLineItem(
                    id: CartLineID(rawValue: "line-2"),
                    variantID: ProductVariantID(rawValue: "variant-2"),
                    product: CartProduct(id: "product-2", title: "T-Shirt"),
                    quantity: 3,
                    unitPrice: Money(amount: 50, currencyCode: "EGP"),
                    totalPrice: Money(amount: 150, currencyCode: "EGP")
                )
            ],
            totals: CartTotals(
                subtotal: Money(amount: 350, currencyCode: "EGP"),
                total: Money(amount: 350, currencyCode: "EGP")
            )
        )

        XCTAssertEqual(cart.totalQuantity, 5)
        XCTAssertFalse(cart.isEmpty)
    }
}
