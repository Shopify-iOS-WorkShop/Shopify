import Foundation
import Common

public protocol AddCartLineUseCaseProtocol {
    func execute(variantId: String, quantity: Int) async -> Result<Cart, AppError>
}

public struct AddCartLineUseCase: AddCartLineUseCaseProtocol {
    private let repository: CartRepositoryProtocol

    public init(repository: CartRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(variantId: String, quantity: Int) async -> Result<Cart, AppError> {
        let input = CartLineInput(variantId: variantId, quantity: quantity)
        return await repository.addLines([input])
    }
}
