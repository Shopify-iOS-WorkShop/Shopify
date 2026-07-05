import Foundation
import Common

public protocol CartRepositoryProtocol {
    func observeCart() -> AsyncStream<Cart?>
    func currentCart() -> Cart?
    func fetchCart() async -> Result<Cart, AppError>
    func createCart() async -> Result<Cart, AppError>
    func addLines(_ lines: [CartLineInput]) async -> Result<Cart, AppError>
    func updateLine(lineId: String, quantity: Int) async -> Result<Cart, AppError>
    func removeLines(_ lineIds: [String]) async -> Result<Cart, AppError>
    func applyDiscountCode(_ code: String) async -> Result<Cart, AppError>
    func removeDiscountCode(_ code: String) async -> Result<Cart, AppError>
    func attachCustomer() async -> Result<Cart, AppError>
    func clearCart() async
}
