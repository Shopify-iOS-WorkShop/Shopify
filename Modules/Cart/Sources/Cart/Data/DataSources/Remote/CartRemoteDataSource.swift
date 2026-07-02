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
        let query = ShopifyNetwork.GetCartQuery(cartId: id)
        let data = try await client.fetch(query: query)
        
        guard let cartFragment = data.cart?.fragments.cartFragment else {
            throw AppError.graphQL(["Cart not found or has expired"])
        }
        return CartMapper.toDTO(from: cartFragment)
    }
    
    func createCart(customerAccessToken: String?) async throws -> CartResponseDTO {
        var buyerIdentity: GraphQLNullable<ShopifyNetwork.CartBuyerIdentityInput> = .none
        if let token = customerAccessToken {
            buyerIdentity = .some(.init(customerAccessToken: .some(token)))
        }
        let input = ShopifyNetwork.CartInput(buyerIdentity: buyerIdentity)
        let mutation = ShopifyNetwork.CartCreateMutation(input: input)
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
            ShopifyNetwork.CartLineInput(
                merchandiseId: dto.variantId,
                quantity: .some(dto.quantity)
            )
        }
        let mutation = ShopifyNetwork.CartLinesAddMutation(cartId: cartId, lines: apolloLines)
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
        let line = ShopifyNetwork.CartLineUpdateInput(id: lineId, quantity: .some(quantity))
        let mutation = ShopifyNetwork.CartLinesUpdateMutation(cartId: cartId, lines: [line])
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
        let mutation = ShopifyNetwork.CartLinesRemoveMutation(cartId: cartId, lineIds: lineIds)
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
        let mutation = ShopifyNetwork.CartDiscountCodesUpdateMutation(
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
        let identity = ShopifyNetwork.CartBuyerIdentityInput(customerAccessToken: .some(customerAccessToken))
        let mutation = ShopifyNetwork.CartBuyerIdentityUpdateMutation(cartId: cartId, buyerIdentity: identity)
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
