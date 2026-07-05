import Foundation

internal protocol CartRemoteDataSourceProtocol {
    func fetchCart(id: String) async throws -> CartResponseDTO
    func createCart(customerAccessToken: String?) async throws -> CartResponseDTO
    func addLines(cartId: String, lines: [CartLineInputDTO]) async throws -> CartResponseDTO
    func updateLine(cartId: String, lineId: String, quantity: Int) async throws -> CartResponseDTO
    func removeLines(cartId: String, lineIds: [String]) async throws -> CartResponseDTO
    func replaceDiscountCodes(cartId: String, codes: [String]) async throws -> CartResponseDTO
    func attachCustomer(cartId: String, customerAccessToken: String) async throws -> CartResponseDTO
}

internal struct CartLineInputDTO {
    let variantId: String
    let quantity: Int
}
