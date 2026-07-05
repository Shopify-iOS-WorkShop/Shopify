import Foundation
import Common

public protocol RemoveCartLineUseCaseProtocol {
    func execute(lineId: String) async -> Result<Cart, AppError>
}

public struct RemoveCartLineUseCase: RemoveCartLineUseCaseProtocol {
    private let repository: CartRepositoryProtocol

    public init(repository: CartRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(lineId: String) async -> Result<Cart, AppError> {
        return await repository.removeLines([lineId])
    }
}
