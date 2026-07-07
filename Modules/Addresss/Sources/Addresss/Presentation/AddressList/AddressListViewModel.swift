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

    /// The default address is always kept around, both because it represents the
    /// customer's primary delivery location and to guarantee that once a customer has
    /// added at least one address, the list never drops back down to zero.
    public func canDelete(_ address: Address) -> Bool {
        !address.isDefault
    }

    @MainActor
    public func delete(_ address: Address) async {
        guard canDelete(address) else {
            errorMessage = AddressError.cannotDeleteDefault.localizedDescription
            return
        }
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
    ///
    /// A brand-new address that lands in an empty list is the customer's only
    /// address, so it's promoted to default automatically — both locally and on
    /// the server — otherwise the customer would have a saved address with no
    /// default at all.
    @MainActor
    public func upsert(_ address: Address) {
        if let index = addresses.firstIndex(where: { $0.id == address.id }) {
            // The update mutation's response doesn't carry default status, so we
            // preserve whatever this address's default state already was locally
            // rather than letting an edit silently un-default it.
            var updated = address
            updated.isDefault = addresses[index].isDefault
            addresses[index] = updated
        } else {
            let isFirstAddress = addresses.isEmpty
            var newAddress = address
            if isFirstAddress {
                newAddress.isDefault = true
            }
            addresses.append(newAddress)

            if isFirstAddress {
                Task {
                    do {
                        try await setDefaultUseCase.execute(id: newAddress.id)
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
}
