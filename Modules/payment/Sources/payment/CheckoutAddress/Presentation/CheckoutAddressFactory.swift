//
//  File.swift
//  
//
//  Created by Mazen Amr on 03/07/2026.
//

import Foundation
import SwiftUI
import Auth

public struct CheckoutAddressFactory {
    
    @MainActor
    public static func makeAddressViewModel() -> CheckoutAddressViewModel {
        let authRepo = AuthRepositoryFactory.make()
        let repository = AddressRepository(authRepository: authRepo)
        
        let getAddressesUseCase = GetSavedAddressesUseCase(repository: repository)
        let updateAddressUseCase = UpdateAddressUseCase(repository: repository)
        
        return CheckoutAddressViewModel(
            getAddressesUseCase: getAddressesUseCase,
            updateAddressUseCase: updateAddressUseCase
        )
    }
}
