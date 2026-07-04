import Foundation
import Combine
import Common

internal final class CartRepositoryImpl: CartRepositoryProtocol {
    private let remoteDataSource: CartRemoteDataSourceProtocol
    private let localDataSource: CartLocalDataSourceProtocol
    private let sessionStore: SessionProviding
    
    private var cartPublisher = CurrentValueSubject<Cart?, Never>(nil)
    
    private var ownerKey: String {
        return sessionStore.current?.firebaseUID ?? "guest"
    }
    
    init(
        remoteDataSource: CartRemoteDataSourceProtocol,
        localDataSource: CartLocalDataSourceProtocol,
        sessionStore: SessionProviding
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.sessionStore = sessionStore
    }
    
    func observeCart() -> AsyncStream<Cart?> {
        AsyncStream { continuation in
            let cancellable = cartPublisher.sink { cart in
                continuation.yield(cart)
            }
            continuation.onTermination = { _ in
                cancellable.cancel()
            }
        }
    }
    
    func currentCart() -> Cart? {
        return cartPublisher.value
    }
    
    func fetchCart() async -> Result<Cart, AppError> {
        let record = await MainActor.run {
            localDataSource.fetchCartRecord(ownerKey: ownerKey)
        }
        
        guard let record else {
            return .failure(AppError.graphQL(["No cart found"]))
        }
        
        let age = Date().timeIntervalSince(record.cartIdCreatedAt)
        if age > 9 * 24 * 60 * 60 {
            await MainActor.run {
                try? localDataSource.deleteCartRecord(ownerKey: ownerKey)
            }
            return .failure(AppError.graphQL(["Cart has likely expired"]))
        }
        
        do {
            let dto = try await remoteDataSource.fetchCart(id: record.cartId)
            let cart = CartMapper.toDomain(from: dto)
            await MainActor.run {
                try? localDataSource.updateCachedQuantity(cart.totalQuantity, ownerKey: ownerKey)
                try? localDataSource.updateCachedCheckoutUrl(cart.checkoutUrl.absoluteString, ownerKey: ownerKey)
            }
            cartPublisher.send(cart)
            return .success(cart)
        } catch let error as AppError {
            if case .graphQL(let messages) = error,
               messages.first?.contains("not found") == true || messages.first?.contains("expired") == true {
                await MainActor.run {
                    try? localDataSource.deleteCartRecord(ownerKey: ownerKey)
                }
            }
            return .failure(error)
        } catch {
            return .failure(.unknown)
        }
    }
    
    func createCart() async -> Result<Cart, AppError> {
        do {
            let customerToken = sessionStore.current?.customerAccessToken
            let dto = try await remoteDataSource.createCart(customerAccessToken: customerToken)
            let cart = CartMapper.toDomain(from: dto)
            
            let record = CartRecord(
                ownerKey: ownerKey,
                cartId: cart.id,
                cartIdCreatedAt: Date(),
                lastKnownCheckoutUrl: cart.checkoutUrl.absoluteString,
                totalQuantity: cart.totalQuantity,
                updatedAt: Date()
            )
            
            try await MainActor.run {
                try localDataSource.saveCartRecord(record)
            }
            
            cartPublisher.send(cart)
            return .success(cart)
        } catch let error as AppError {
            return .failure(error)
        } catch {
            return .failure(.unknown)
        }
    }
    
    func addLines(_ lines: [CartLineInput]) async -> Result<Cart, AppError> {
        let record = await MainActor.run {
            localDataSource.fetchCartRecord(ownerKey: ownerKey)
        }
        
        guard let record else {
            return .failure(AppError.unknown)
        }
        
        do {
            let dtos = lines.map { CartLineInputDTO(variantId: $0.variantId, quantity: $0.quantity) }
            let dto = try await remoteDataSource.addLines(cartId: record.cartId, lines: dtos)
            let cart = CartMapper.toDomain(from: dto)
            
            await MainActor.run {
                try? localDataSource.updateCachedQuantity(cart.totalQuantity, ownerKey: ownerKey)
            }
            
            cartPublisher.send(cart)
            return .success(cart)
        } catch let error as AppError {
            return .failure(error)
        } catch {
            return .failure(.unknown)
        }
    }
    
    func updateLine(lineId: String, quantity: Int) async -> Result<Cart, AppError> {
        let record = await MainActor.run {
            localDataSource.fetchCartRecord(ownerKey: ownerKey)
        }
        
        guard let record else {
            return .failure(AppError.unknown)
        }
        
        do {
            let dto = try await remoteDataSource.updateLine(cartId: record.cartId, lineId: lineId, quantity: quantity)
            let cart = CartMapper.toDomain(from: dto)
            
            await MainActor.run {
                try? localDataSource.updateCachedQuantity(cart.totalQuantity, ownerKey: ownerKey)
            }
            
            cartPublisher.send(cart)
            return .success(cart)
        } catch let error as AppError {
            return .failure(error)
        } catch {
            return .failure(.unknown)
        }
    }
    
    func removeLines(_ lineIds: [String]) async -> Result<Cart, AppError> {
        let record = await MainActor.run {
            localDataSource.fetchCartRecord(ownerKey: ownerKey)
        }
        
        guard let record else {
            return .failure(AppError.unknown)
        }
        
        do {
            let dto = try await remoteDataSource.removeLines(cartId: record.cartId, lineIds: lineIds)
            let cart = CartMapper.toDomain(from: dto)
            
            await MainActor.run {
                try? localDataSource.updateCachedQuantity(cart.totalQuantity, ownerKey: ownerKey)
            }
            
            cartPublisher.send(cart)
            return .success(cart)
        } catch let error as AppError {
            return .failure(error)
        } catch {
            return .failure(.unknown)
        }
    }
    
    func applyDiscountCode(_ code: String) async -> Result<Cart, AppError> {
        let record = await MainActor.run {
            localDataSource.fetchCartRecord(ownerKey: ownerKey)
        }
        
        guard let record else {
            return .failure(AppError.unknown)
        }
        
        do {
            let dto = try await remoteDataSource.replaceDiscountCodes(cartId: record.cartId, codes: [code])
            let cart = CartMapper.toDomain(from: dto)
            cartPublisher.send(cart)
            return .success(cart)
        } catch let error as AppError {
            return .failure(error)
        } catch {
            return .failure(.unknown)
        }
    }
    
    func removeDiscountCode(_ code: String) async -> Result<Cart, AppError> {
        let record = await MainActor.run {
            localDataSource.fetchCartRecord(ownerKey: ownerKey)
        }
        
        guard let record else {
            return .failure(AppError.unknown)
        }
        
        do {
            // Removing a discount code is done by replacing discount codes with an empty array
            let dto = try await remoteDataSource.replaceDiscountCodes(cartId: record.cartId, codes: [])
            let cart = CartMapper.toDomain(from: dto)
            cartPublisher.send(cart)
            return .success(cart)
        } catch let error as AppError {
            return .failure(error)
        } catch {
            return .failure(.unknown)
        }
    }
    
    func attachCustomer() async -> Result<Cart, AppError> {
        let (record, customerToken) = await MainActor.run {
            (localDataSource.fetchCartRecord(ownerKey: ownerKey),
             sessionStore.current?.customerAccessToken)
        }
        
        guard let record, let customerToken else {
            return .failure(AppError.unknown)
        }
        
        do {
            let dto = try await remoteDataSource.attachCustomer(cartId: record.cartId, customerAccessToken: customerToken)
            let cart = CartMapper.toDomain(from: dto)
            cartPublisher.send(cart)
            return .success(cart)
        } catch let error as AppError {
            return .failure(error)
        } catch {
            return .failure(.unknown)
        }
    }
    
    func clearCart() async {
        await MainActor.run {
            try? localDataSource.deleteCartRecord(ownerKey: ownerKey)
        }
        cartPublisher.send(nil)
    }
}
