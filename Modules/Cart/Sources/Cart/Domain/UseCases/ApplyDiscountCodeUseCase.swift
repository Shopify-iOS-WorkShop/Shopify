import Foundation
import Common

public protocol ApplyDiscountCodeUseCaseProtocol {
    func execute(code: String) async -> Result<Cart, AppError>
}

public struct ApplyDiscountCodeUseCase: ApplyDiscountCodeUseCaseProtocol {
    private let repository: CartRepositoryProtocol

    public init(repository: CartRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(code: String) async -> Result<Cart, AppError> {
        return await repository.applyDiscountCode(code)
    }
}
