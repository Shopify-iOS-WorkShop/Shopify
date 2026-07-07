//
//  File.swift
//  
//
//  Created by Mazen Amr on 03/07/2026.
//

import Foundation
import SwiftUI

@MainActor
public class CheckoutAddressViewModel: ObservableObject {
    @Published public var savedAddresses: [Address] = []
    @Published public var selectedAddress: Address?
    
    @Published public var recipientName: String = ""
    @Published public var mobileNumber: String = ""
    @Published public var city: String = ""
    @Published public var street: String = ""
    @Published public var country: String = ""
    
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    @Published public var showUpdateAlert: Bool = false
    
    private let getAddressesUseCase: GetSavedAddressesUseCaseProtocol
    private let updateAddressUseCase: UpdateAddressUseCaseProtocol
    
    public init(
        getAddressesUseCase: GetSavedAddressesUseCaseProtocol,
        updateAddressUseCase: UpdateAddressUseCaseProtocol
    ) {
        self.getAddressesUseCase = getAddressesUseCase
        self.updateAddressUseCase = updateAddressUseCase
    }
    
    public func loadAddresses() async {
        isLoading = true
        do {
            savedAddresses = try await getAddressesUseCase.execute()
            if selectedAddress == nil, let first = savedAddresses.first {
                selectAddress(first)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    public func selectAddress(_ address: Address) {
        selectedAddress = address
        recipientName = address.recipientName
        mobileNumber = address.mobileNumber
        city = address.city
        street = address.street
        country = address.country
    }
    
    private func hasModifications() -> Bool {
        guard let original = selectedAddress else { return false }
        return recipientName != original.recipientName ||
               mobileNumber != original.mobileNumber ||
               city != original.city ||
               street != original.street ||
               country != original.country
    }
    
    
    public func prepareForCheckout() -> Bool {
        let name = recipientName.trimmingCharacters(in: .whitespaces)
        let num = mobileNumber.trimmingCharacters(in: .whitespaces)
        let cty = city.trimmingCharacters(in: .whitespaces)
        let str = street.trimmingCharacters(in: .whitespaces)
        
        guard !name.isEmpty, !num.isEmpty, !cty.isEmpty, !str.isEmpty else {
            errorMessage = "Please fill in all fields"
            return false
        }
        
        let nameComponents = name.components(separatedBy: " ")
        guard nameComponents.count >= 2 else {
            errorMessage = "Please enter both your first and last name"
            return false
        }
        
        if hasModifications() {
            showUpdateAlert = true
            return false
        }
        
        return true
    }
    
    public func confirmAndSaveAddress() async -> Bool {
        guard let original = selectedAddress else { return false }
        
        let updatedAddress = Address(
            id: original.id,
            title: original.title,
            details: "\(street)\n\(city)",
            recipientName: recipientName,
            mobileNumber: mobileNumber,
            city: city,
            street: street
        )
        
        isLoading = true
        do {
            try await updateAddressUseCase.execute(address: updatedAddress)
            self.selectedAddress = updatedAddress
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    public func revertAddressChanges() {
        guard let originalAddress = selectedAddress else { return }
        self.recipientName = originalAddress.recipientName
        self.mobileNumber = originalAddress.mobileNumber
        self.city = originalAddress.city
        self.street = originalAddress.street
        self.country = originalAddress.country
    }
}
