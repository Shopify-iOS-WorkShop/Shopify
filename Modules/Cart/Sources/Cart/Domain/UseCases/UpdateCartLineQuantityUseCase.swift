import Foundation
import Common

public protocol UpdateCartLineQuantityUseCaseProtocol {
    func execute(lineId: String, quantity: Int) async -> Result<Cart, AppError>
}

public struct UpdateCartLineQuantityUseCase: UpdateCartLineQuantityUseCaseProtocol {
    private let repository: CartRepositoryProtocol

    public init(repository: CartRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(lineId: String, quantity: Int) async -> Result<Cart, AppError> {
        return await repository.updateLine(lineId: lineId, quantity: quantity)
    }
}
