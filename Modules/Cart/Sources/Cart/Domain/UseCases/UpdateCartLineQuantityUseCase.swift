import Foundation
import Common

public protocol UpdateCartLineQuantityUseCaseProtocol {
    func execute(lineId: String, newQuantity: Int, quantityAvailable: Int?) async -> Result<Cart, AppError>
}

public struct UpdateCartLineQuantityUseCase: UpdateCartLineQuantityUseCaseProtocol {
    private let repository: CartRepositoryProtocol

    public init(repository: CartRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(lineId: String, newQuantity: Int, quantityAvailable: Int?) async -> Result<Cart, AppError> {
        // Validate quantity
        guard newQuantity >= 1 else {
            return .failure(.validation("Quantity must be at least 1"))
        }
        
        if let max = quantityAvailable, newQuantity > max {
            return .failure(.validation("Maximum available: \(max)"))
        }
        
        if let max = quantityAvailable, max == 0 {
            return .failure(.validation("This item is out of stock"))
        }
        
        return await repository.updateLine(lineId: lineId, quantity: newQuantity)
    }
}
