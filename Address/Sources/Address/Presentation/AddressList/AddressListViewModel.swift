//
//  AddressListViewModel.swift
//  Address
//
//  Created by Mina Nashaat on 05/07/2026.
//

import Foundation
import Observation

@Observable
public final class AddressListViewModel {

    public private(set) var addresses: [Address] = []
    public var isLoading: Bool = false
    public var errorMessage: String?

    private let fetchUseCase: FetchSavedAddressesUseCase
    private let deleteUseCase: DeleteAddressUseCase
    private let setDefaultUseCase: SetDefaultAddressUseCase

    public init(
        fetchUseCase: FetchSavedAddressesUseCase,
        deleteUseCase: DeleteAddressUseCase,
        setDefaultUseCase: SetDefaultAddressUseCase
    ) {
        self.fetchUseCase = fetchUseCase
        self.deleteUseCase = deleteUseCase
        self.setDefaultUseCase = setDefaultUseCase
    }

    @MainActor
    public func loadAddresses() async {
        isLoading = true
        errorMessage = nil
        do {
            addresses = try await fetchUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    @MainActor
    public func delete(_ address: Address) async {
        do {
            try await deleteUseCase.execute(id: address.id)
            addresses.removeAll { $0.id == address.id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    public func setDefault(_ address: Address) async {
        do {
            try await setDefaultUseCase.execute(id: address.id)
            addresses = addresses.map { current in
                var updated = current
                updated.isDefault = (current.id == address.id)
                return updated
            }
            if let index = addresses.firstIndex(where: { $0.isDefault }), index != 0 {
                let defaultAddress = addresses.remove(at: index)
                addresses.insert(defaultAddress, at: 0)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    /// Called after returning from Add/Edit so the list reflects the change
    /// immediately without a full refetch.
    @MainActor
    public func upsert(_ address: Address) {
        if let index = addresses.firstIndex(where: { $0.id == address.id }) {
            addresses[index] = address
        } else {
            addresses.append(address)
        }
    }
}
