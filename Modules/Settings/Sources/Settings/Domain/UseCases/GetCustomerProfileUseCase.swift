//
//  GetCustomerProfileUseCase.swift
//  Settings — Domain
//

import Foundation
import Common

public final class GetCustomerProfileUseCase {
    private let repository: SettingsRepositoryProtocol
    private let sessionStore: SessionProviding

    public init(repository: SettingsRepositoryProtocol, sessionStore: SessionProviding) {
        self.repository = repository
        self.sessionStore = sessionStore
    }

    public func execute() async -> Result<CustomerProfile, SettingsError> {
        guard let token = sessionStore.current?.customerAccessToken, !token.isEmpty else {
            return .failure(.notAuthenticated)
        }
        return await repository.getCustomerProfile(customerAccessToken: token)
    }
}
