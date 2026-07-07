//
//  AddressAssembly.swift
//  Address
//
//  Created by Mina Nashaat on 05/07/2026.
//

import Foundation
import DependencyInjection
import Swinject
import Auth
import ShopifyNetwork

// MARK: - Address Assembly for Dependency Injection
public class AddressAssembly: DIAssembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(AddressRepositoryProtocol.self) { resolver in
            AddressRepository(
                networkClient: resolver.resolve(NetworkClient.self) ?? URLSessionNetworkClient(),
                authRepository: resolver.resolve(AuthRepositoryProtocol.self)!
            )
        }

        container.register(FetchSavedAddressesUseCase.self) { resolver in
            FetchSavedAddressesUseCase(repository: resolver.resolve(AddressRepositoryProtocol.self)!)
        }

        container.register(AddAddressUseCase.self) { resolver in
            AddAddressUseCase(repository: resolver.resolve(AddressRepositoryProtocol.self)!)
        }

        container.register(UpdateAddressUseCase.self) { resolver in
            UpdateAddressUseCase(repository: resolver.resolve(AddressRepositoryProtocol.self)!)
        }

        container.register(DeleteAddressUseCase.self) { resolver in
            DeleteAddressUseCase(repository: resolver.resolve(AddressRepositoryProtocol.self)!)
        }

        container.register(SetDefaultAddressUseCase.self) { resolver in
            SetDefaultAddressUseCase(repository: resolver.resolve(AddressRepositoryProtocol.self)!)
        }

        container.register(AddressListViewModel.self) { resolver in
            AddressListViewModel(
                fetchUseCase: resolver.resolve(FetchSavedAddressesUseCase.self)!,
                deleteUseCase: resolver.resolve(DeleteAddressUseCase.self)!,
                setDefaultUseCase: resolver.resolve(SetDefaultAddressUseCase.self)!
            )
        }

        container.register(AddressViewModelFactory.self) { resolver in
            AddressViewModelFactory(
                addUseCase: resolver.resolve(AddAddressUseCase.self)!,
                updateUseCase: resolver.resolve(UpdateAddressUseCase.self)!
            )
        }
    }
}

public struct AddressViewModelFactory {
    private let addUseCase: AddAddressUseCase
    private let updateUseCase: UpdateAddressUseCase

    public init(addUseCase: AddAddressUseCase, updateUseCase: UpdateAddressUseCase) {
        self.addUseCase = addUseCase
        self.updateUseCase = updateUseCase
    }

    public func makeAddAddressViewModel(editing address: Address?) -> AddAddressViewModel {
        AddAddressViewModel(addUseCase: addUseCase, updateUseCase: updateUseCase, editing: address)
    }
}
