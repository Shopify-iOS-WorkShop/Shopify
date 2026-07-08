import Foundation
import Combine
import Common

internal final class CartRepositoryImpl: CartRepositoryProtocol {
    private let remoteDataSource: CartRemoteDataSourceProtocol
    private let localDataSource: CartLocalDataSourceProtocol
    private let sessionStore: SessionProviding

    private var cartPublisher = CurrentValueSubject<Cart?, Never>(nil)

    private var ownerKey: String {
        sessionStore.current?.firebaseUID ?? "guest"
    }

    init(
        remoteDataSource: CartRemoteDataSourceProtocol,
        localDataSource: CartLocalDataSourceProtocol,
        sessionStore: SessionProviding
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource  = localDataSource
        self.sessionStore     = sessionStore
    }

    // MARK: - observeCart
    func observeCart() -> AsyncStream<Cart?> {
        AsyncStream { continuation in
            let cancellable = cartPublisher.sink { continuation.yield($0) }
            continuation.onTermination = { _ in cancellable.cancel() }
        }
    }

    // MARK: - currentCart
    func currentCart() -> Cart? { cartPublisher.value }

    // MARK: - fetchCart
    func fetchCart() async -> Result<Cart, AppError> {
        // Extract only Sendable values — CartRecord stays inside MainActor.run
        let snapshot = await MainActor.run { () -> (cartId: String, createdAt: Date)? in
            guard let r = localDataSource.fetchCartRecord(ownerKey: ownerKey) else { return nil }
            return (r.cartId, r.cartIdCreatedAt)
        }

        guard let snapshot else {
            return .failure(.graphQL(["No cart found"]))
        }

        if Date().timeIntervalSince(snapshot.createdAt) > 9 * 24 * 60 * 60 {
            await MainActor.run { try? localDataSource.deleteCartRecord(ownerKey: ownerKey) }
            return .failure(.graphQL(["Cart has likely expired"]))
        }

        do {
            let dto  = try await remoteDataSource.fetchCart(id: snapshot.cartId)
            let cart = CartMapper.toDomain(from: dto)
            await MainActor.run {
                try? localDataSource.updateCachedQuantity(cart.totalQuantity, ownerKey: ownerKey)
                try? localDataSource.updateCachedCheckoutUrl(cart.checkoutUrl.absoluteString, ownerKey: ownerKey)
            }
            cartPublisher.send(cart)
            return .success(cart)
        } catch let error as AppError {
            await checkAndClearInvalidCart(error: error)
            return .failure(error)
        } catch {
            return .failure(.unknown)
        }
    }

    // MARK: - createCart
    func createCart() async -> Result<Cart, AppError> {
        do {
            let customerToken = sessionStore.current?.customerAccessToken
            let dto  = try await remoteDataSource.createCart(customerAccessToken: customerToken)
            let cart = CartMapper.toDomain(from: dto)

            // Only plain Sendable types cross the boundary; CartRecord is built inside MainActor.run
            let ownerKey      = self.ownerKey
            let cartId        = cart.id
            let checkoutUrl   = cart.checkoutUrl.absoluteString
            let totalQuantity = cart.totalQuantity
            let now           = Date()

            try await MainActor.run {
                let record = CartRecord(
                    ownerKey: ownerKey,
                    cartId: cartId,
                    cartIdCreatedAt: now,
                    lastKnownCheckoutUrl: checkoutUrl,
                    totalQuantity: totalQuantity,
                    updatedAt: now
                )
                try localDataSource.saveCartRecord(record)
            }

            cartPublisher.send(cart)
            return .success(cart)
        } catch let error as AppError { return .failure(error) }
          catch { return .failure(.unknown) }
    }

    // MARK: - addLines
    func addLines(_ lines: [CartLineInput]) async -> Result<Cart, AppError> {
        let cartId = await MainActor.run { () -> String? in
            localDataSource.fetchCartRecord(ownerKey: ownerKey)?.cartId
        }
        guard let cartId else { return .failure(.unknown) }

        do {
            let dtos = lines.map { CartLineInputDTO(variantId: $0.variantId, quantity: $0.quantity) }
            let dto  = try await remoteDataSource.addLines(cartId: cartId, lines: dtos)
            let cart = CartMapper.toDomain(from: dto)
            await MainActor.run { try? localDataSource.updateCachedQuantity(cart.totalQuantity, ownerKey: ownerKey) }
            cartPublisher.send(cart)
            return .success(cart)
        } catch let error as AppError {
            await checkAndClearInvalidCart(error: error)
            return .failure(error)
        } catch {
            return .failure(.unknown)
        }
    }

    // MARK: - updateLine
    func updateLine(lineId: String, quantity: Int) async -> Result<Cart, AppError> {
        let cartId = await MainActor.run { () -> String? in
            localDataSource.fetchCartRecord(ownerKey: ownerKey)?.cartId
        }
        guard let cartId else { return .failure(.unknown) }

        do {
            let dto  = try await remoteDataSource.updateLine(cartId: cartId, lineId: lineId, quantity: quantity)
            let cart = CartMapper.toDomain(from: dto)
            await MainActor.run { try? localDataSource.updateCachedQuantity(cart.totalQuantity, ownerKey: ownerKey) }
            cartPublisher.send(cart)
            return .success(cart)
        } catch let error as AppError {
            await checkAndClearInvalidCart(error: error)
            return .failure(error)
        } catch {
            return .failure(.unknown)
        }
    }

    // MARK: - removeLines
    func removeLines(_ lineIds: [String]) async -> Result<Cart, AppError> {
        let cartId = await MainActor.run { () -> String? in
            localDataSource.fetchCartRecord(ownerKey: ownerKey)?.cartId
        }
        guard let cartId else { return .failure(.unknown) }

        do {
            let dto  = try await remoteDataSource.removeLines(cartId: cartId, lineIds: lineIds)
            let cart = CartMapper.toDomain(from: dto)
            await MainActor.run { try? localDataSource.updateCachedQuantity(cart.totalQuantity, ownerKey: ownerKey) }
            cartPublisher.send(cart)
            return .success(cart)
        } catch let error as AppError {
            await checkAndClearInvalidCart(error: error)
            return .failure(error)
        } catch {
            return .failure(.unknown)
        }
    }

    // MARK: - applyDiscountCode
    func applyDiscountCode(_ code: String) async -> Result<Cart, AppError> {
        let cartId = await MainActor.run { () -> String? in
            localDataSource.fetchCartRecord(ownerKey: ownerKey)?.cartId
        }
        guard let cartId else { return .failure(.unknown) }

        do {
            let dto  = try await remoteDataSource.replaceDiscountCodes(cartId: cartId, codes: [code])
            let cart = CartMapper.toDomain(from: dto)
            cartPublisher.send(cart)
            return .success(cart)
        } catch let error as AppError {
            await checkAndClearInvalidCart(error: error)
            return .failure(error)
        } catch {
            return .failure(.unknown)
        }
    }

    // MARK: - removeDiscountCode
    func removeDiscountCode(_ code: String) async -> Result<Cart, AppError> {
        let cartId = await MainActor.run { () -> String? in
            localDataSource.fetchCartRecord(ownerKey: ownerKey)?.cartId
        }
        guard let cartId else { return .failure(.unknown) }

        do {
            // Removing = replacing with empty array
            let dto  = try await remoteDataSource.replaceDiscountCodes(cartId: cartId, codes: [])
            let cart = CartMapper.toDomain(from: dto)
            cartPublisher.send(cart)
            return .success(cart)
        } catch let error as AppError {
            await checkAndClearInvalidCart(error: error)
            return .failure(error)
        } catch {
            return .failure(.unknown)
        }
    }

    // MARK: - attachCustomer
    func attachCustomer() async -> Result<Cart, AppError> {
        let snapshot = await MainActor.run { () -> (cartId: String, token: String)? in
            guard let r     = localDataSource.fetchCartRecord(ownerKey: ownerKey),
                  let token = sessionStore.current?.customerAccessToken else { return nil }
            return (r.cartId, token)
        }
        guard let snapshot else { return .failure(.unknown) }

        do {
            let dto  = try await remoteDataSource.attachCustomer(
                cartId: snapshot.cartId,
                customerAccessToken: snapshot.token
            )
            let cart = CartMapper.toDomain(from: dto)
            cartPublisher.send(cart)
            return .success(cart)
        } catch let error as AppError {
            await checkAndClearInvalidCart(error: error)
            return .failure(error)
        } catch {
            return .failure(.unknown)
        }
    }

    // MARK: - clearCart
    func clearCart() async {
        await MainActor.run { try? localDataSource.deleteCartRecord(ownerKey: ownerKey) }
        cartPublisher.send(nil)
    }

    // MARK: - Helpers
    private func checkAndClearInvalidCart(error: AppError) async {
        if case .graphQL(let msgs) = error {
            let isInvalid = msgs.contains { msg in
                msg.lowercased().contains("not found") ||
                msg.lowercased().contains("expired") ||
                msg.lowercased().contains("does not exist") ||
                msg.lowercased().contains("invalid")
            }
            if isInvalid {
                await MainActor.run { try? localDataSource.deleteCartRecord(ownerKey: ownerKey) }
                cartPublisher.send(nil) // Ensure the UI clears the cart so it fetches a new one
            }
        }
    }
}
