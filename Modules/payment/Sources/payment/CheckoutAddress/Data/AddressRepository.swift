//
//  File.swift
//  
//
//  Created by Mazen Amr on 03/07/2026.
//

import Foundation
import ShopifyNetwork
import Auth

public final class AddressRepository: AddressRepositoryProtocol {
    private let client: GraphQLClientProtocol
    private let authRepository: AuthRepositoryProtocol
    
    public init(
        client: GraphQLClientProtocol = GraphQLClient.shared,
        authRepository: AuthRepositoryProtocol
    ) {
        self.client = client
        self.authRepository = authRepository
    }
    
    private func getCustomerToken() throws -> String {
        guard let session = authRepository.currentSession() else {
            throw AddressError.missingToken
        }
        return session.customerAccessToken
    }
    
    public func fetchSavedAddresses() async throws -> [Address] {
        let token = try getCustomerToken()
        let query = ShopifyAPI.GetCustomerAddressesQuery(customerAccessToken: token)
        let data = try await client.fetch(query: query)
        
        let defaultAddressId = data.customer?.defaultAddress?.id
        guard var edges = data.customer?.addresses.edges else { return [] }
        
        if let defaultId = defaultAddressId,
           let defaultIndex = edges.firstIndex(where: { $0.node.id == defaultId }) {
            let defaultEdge = edges.remove(at: defaultIndex)
            edges.insert(defaultEdge, at: 0)
        }
        
        return edges.enumerated().map { index, edge in
            let node = edge.node
            let isDefault = (node.id == defaultAddressId)
            let addressTitle = isDefault ? "Default Address" : "Address \(index + 1)"
            
            return Address(
                id: node.id,
                title: addressTitle,
                details: "\(node.address1 ?? "")\n\(node.city ?? "")",
                recipientName: "\(node.firstName ?? "") \(node.lastName ?? "")".trimmingCharacters(in: .whitespaces),
                mobileNumber: node.phone ?? "",
                city: node.city ?? "",
                street: node.address1 ?? ""
            )
        }
        }
    

    public func updateAddress(_ address: Address) async throws {
            let token = try getCustomerToken()
            let nameParts = address.recipientName.components(separatedBy: " ")
            
            let input = ShopifyAPI.MailingAddressInput(
                address1: .some(address.street),
                city: .some(address.city),
                country: .some("EG"),
                firstName: .some(nameParts.first ?? ""),
                lastName: .some(nameParts.dropFirst().joined(separator: " ")),
                phone: .some(address.mobileNumber)
            )
            
            let mutation = ShopifyAPI.CustomerAddressUpdateMutation(customerAccessToken: token, id: address.id, address: input)
            let data = try await client.perform(mutation: mutation)
            
            if let errorMessage = data.customerAddressUpdate?.customerUserErrors.first?.message {
                throw AddressError.apiError(errorMessage)
            }
        }
}


