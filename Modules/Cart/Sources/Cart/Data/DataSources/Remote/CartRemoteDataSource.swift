import Foundation
import ApolloAPI
import ShopifyNetwork
import Common

internal final class CartRemoteDataSource: CartRemoteDataSourceProtocol {
    private let client: GraphQLClientProtocol
    
    init(client: GraphQLClientProtocol) {
        self.client = client
    }
    
    func fetchCart(id: String) async throws -> CartResponseDTO {
        let query = GetCartQuery(cartId: id)
        let data = try await client.fetch(query: query)
        
        guard let cartFragment = data.cart?.fragments.cartFragment else {
            throw AppError.graphQL(["Cart not found or has expired"])
        }
        return CartMapper.toDTO(from: cartFragment)
    }
    
    func createCart(customerAccessToken: String?) async throws -> CartResponseDTO {
        var buyerIdentity: GraphQLNullable<CartBuyerIdentityInput> = .none
        if let token = customerAccessToken {
            buyerIdentity = .some(.init(customerAccessToken: .some(token)))
        }
        let input = CartInput(buyerIdentity: buyerIdentity)
        let mutation = CartCreateMutation(input: input)
        let data = try await client.perform(mutation: mutation)
        
        if let errors = data.cartCreate?.userErrors, !errors.isEmpty {
            throw AppError.graphQL(errors.map { $0.message })
        }
        guard let cartFragment = data.cartCreate?.cart?.fragments.cartFragment else {
            throw AppError.unknown
        }
        return CartMapper.toDTO(from: cartFragment)
    }
    
    func addLines(cartId: String, lines: [CartLineInputDTO]) async throws -> CartResponseDTO {
        let apolloLines = lines.map { dto in
            CartLineInput(
                merchandiseId: dto.variantId,
                quantity: .some(dto.quantity)
            )
        }
        let mutation = CartLinesAddMutation(cartId: cartId, lines: apolloLines)
        let data = try await client.perform(mutation: mutation)
        
        if let errors = data.cartLinesAdd?.userErrors, !errors.isEmpty {
            throw AppError.graphQL(errors.map { $0.message })
        }
        guard let cartFragment = data.cartLinesAdd?.cart?.fragments.cartFragment else {
            throw AppError.unknown
        }
        return CartMapper.toDTO(from: cartFragment)
    }
    
    func updateLine(cartId: String, lineId: String, quantity: Int) async throws -> CartResponseDTO {
        let line = CartLineUpdateInput(id: lineId, quantity: .some(quantity))
        let mutation = CartLinesUpdateMutation(cartId: cartId, lines: [line])
        let data = try await client.perform(mutation: mutation)
        
        if let errors = data.cartLinesUpdate?.userErrors, !errors.isEmpty {
            throw AppError.graphQL(errors.map { $0.message })
        }
        guard let cartFragment = data.cartLinesUpdate?.cart?.fragments.cartFragment else {
            throw AppError.unknown
        }
        return CartMapper.toDTO(from: cartFragment)
    }
    
    func removeLines(cartId: String, lineIds: [String]) async throws -> CartResponseDTO {
        let mutation = CartLinesRemoveMutation(cartId: cartId, lineIds: lineIds)
        let data = try await client.perform(mutation: mutation)
        
        if let errors = data.cartLinesRemove?.userErrors, !errors.isEmpty {
            throw AppError.graphQL(errors.map { $0.message })
        }
        guard let cartFragment = data.cartLinesRemove?.cart?.fragments.cartFragment else {
            throw AppError.unknown
        }
        return CartMapper.toDTO(from: cartFragment)
    }
    
    func replaceDiscountCodes(cartId: String, codes: [String]) async throws -> CartResponseDTO {
        let mutation = CartDiscountCodesUpdateMutation(
            cartId: cartId,
            discountCodes: .some(codes)
        )
        let data = try await client.perform(mutation: mutation)
        
        if let errors = data.cartDiscountCodesUpdate?.userErrors, !errors.isEmpty {
            throw AppError.graphQL(errors.map { $0.message })
        }
        guard let cartFragment = data.cartDiscountCodesUpdate?.cart?.fragments.cartFragment else {
            throw AppError.unknown
        }
        return CartMapper.toDTO(from: cartFragment)
    }
    
    func attachCustomer(cartId: String, customerAccessToken: String) async throws -> CartResponseDTO {
        let identity = CartBuyerIdentityInput(customerAccessToken: .some(customerAccessToken))
        let mutation = CartBuyerIdentityUpdateMutation(cartId: cartId, buyerIdentity: identity)
        let data = try await client.perform(mutation: mutation)
        
        if let errors = data.cartBuyerIdentityUpdate?.userErrors, !errors.isEmpty {
            throw AppError.graphQL(errors.map { $0.message })
        }
        guard let cartFragment = data.cartBuyerIdentityUpdate?.cart?.fragments.cartFragment else {
            throw AppError.unknown
        }
        return CartMapper.toDTO(from: cartFragment)
    }
}
