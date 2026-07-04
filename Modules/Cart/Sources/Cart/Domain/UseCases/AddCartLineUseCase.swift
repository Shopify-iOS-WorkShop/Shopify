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
        // If the variant is already in the cart, update its quantity instead of adding a new line
        if let currentCart = repository.currentCart(),
           let existingLine = currentCart.lines.first(where: { $0.variantId == variantId }) {
            let newQuantity = existingLine.quantity + quantity
            return await repository.updateLine(lineId: existingLine.id, quantity: newQuantity)
        }

        let input = CartLineInput(variantId: variantId, quantity: quantity)
        
        // Try adding directly
        let addResult = await repository.addLines([input])
        
        if case .failure = addResult {
            // Cart might not exist or might have expired. Try creating it.
            let createResult = await repository.createCart()
            if case .success = createResult {
                // Now try adding again
                return await repository.addLines([input])
            }
        }
        
        return addResult
    }
}
