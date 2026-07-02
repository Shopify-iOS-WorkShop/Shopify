import Foundation
import Common

public protocol AttachCustomerToCartUseCaseProtocol {
    func execute() async -> Result<Cart, AppError>
}

public struct AttachCustomerToCartUseCase: AttachCustomerToCartUseCaseProtocol {
    private let repository: CartRepositoryProtocol

    public init(repository: CartRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() async -> Result<Cart, AppError> {
        return await repository.attachCustomer()
    }
}
