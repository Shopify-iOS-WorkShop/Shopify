import Foundation
import Common

public protocol RemoveDiscountCodeUseCaseProtocol {
    func execute(code: String) async -> Result<Cart, AppError>
}

public struct RemoveDiscountCodeUseCase: RemoveDiscountCodeUseCaseProtocol {
    private let repository: CartRepositoryProtocol

    public init(repository: CartRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(code: String) async -> Result<Cart, AppError> {
        return await repository.removeDiscountCode(code)
    }
}
