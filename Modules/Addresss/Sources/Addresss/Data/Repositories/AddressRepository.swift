//
//  AddressRepository.swift
//  Address
//
//  Created by Mina Nashaat on 05/07/2026.


import Foundation
import ShopifyNetwork
import Auth

public final class AddressRepository: AddressRepositoryProtocol {

    private let networkClient: NetworkClient
    private let authRepository: AuthRepositoryProtocol

    public init(
        networkClient: NetworkClient = URLSessionNetworkClient(),
        authRepository: AuthRepositoryProtocol
    ) {
        self.networkClient = networkClient
        self.authRepository = authRepository
    }

    private func getCustomerToken() throws -> String {
        guard let session = authRepository.currentSession(), session.isValid else {
            throw AddressError.missingToken
        }
        return session.customerAccessToken
    }

    public func fetchSavedAddresses() async throws -> [Address] {
        let token = try getCustomerToken()

        let endpoint = AddressGraphQLEndpoint(
            query: AddressGraphQLOperations.fetchAddresses,
            variables: FetchAddressesVariables(customerAccessToken: token)
        )

        let envelope: GraphQLEnvelope<GetCustomerAddressesData> = try await send(endpoint)

        guard let customer = envelope.data?.customer else { return [] }
        let defaultId = customer.defaultAddress?.id

        var addresses = customer.addresses.edges.map { edge in
            edge.node.toDomain(isDefault: edge.node.id == defaultId)
        }

        if let defaultIndex = addresses.firstIndex(where: { $0.isDefault }), defaultIndex != 0 {
            let defaultAddress = addresses.remove(at: defaultIndex)
            addresses.insert(defaultAddress, at: 0)
        }

        return addresses
    }


    public func addAddress(_ draft: AddressDraft) async throws -> Address {
        let token = try getCustomerToken()

        let endpoint = AddressGraphQLEndpoint(
            query: AddressGraphQLOperations.createAddress,
            variables: CreateAddressVariables(
                customerAccessToken: token,
                address: draft.toInputDTO()
            )
        )

        let envelope: GraphQLEnvelope<CustomerAddressCreateData> = try await send(endpoint)

        if let userError = envelope.data?.customerAddressCreate?.customerUserErrors.first {
            throw AddressError.apiError(userError.message)
        }

        guard let dto = envelope.data?.customerAddressCreate?.customerAddress else {
            throw AddressError.network("Address could not be created.")
        }

        return dto.toDomain(isDefault: false)
    }


    public func updateAddress(_ draft: AddressDraft) async throws -> Address {
        let token = try getCustomerToken()
        guard let id = draft.id else {
            throw AddressError.notFound
        }

        let endpoint = AddressGraphQLEndpoint(
            query: AddressGraphQLOperations.updateAddress,
            variables: UpdateAddressVariables(
                customerAccessToken: token,
                id: id,
                address: draft.toInputDTO()
            )
        )

        let envelope: GraphQLEnvelope<CustomerAddressUpdateData> = try await send(endpoint)

        if let userError = envelope.data?.customerAddressUpdate?.customerUserErrors.first {
            throw AddressError.apiError(userError.message)
        }

        guard let dto = envelope.data?.customerAddressUpdate?.customerAddress else {
            throw AddressError.network("Address could not be updated.")
        }

        return dto.toDomain(isDefault: false)
    }


    public func deleteAddress(id: String) async throws {
        let token = try getCustomerToken()

        let endpoint = AddressGraphQLEndpoint(
            query: AddressGraphQLOperations.deleteAddress,
            variables: DeleteAddressVariables(customerAccessToken: token, id: id)
        )

        let envelope: GraphQLEnvelope<CustomerAddressDeleteData> = try await send(endpoint)

        if let userError = envelope.data?.customerAddressDelete?.customerUserErrors.first {
            throw AddressError.apiError(userError.message)
        }

        if envelope.data?.customerAddressDelete?.deletedCustomerAddressId == nil {
            throw AddressError.notFound
        }
    }


    public func setDefaultAddress(id: String) async throws {
        let token = try getCustomerToken()

        let endpoint = AddressGraphQLEndpoint(
            query: AddressGraphQLOperations.setDefaultAddress,
            variables: SetDefaultAddressVariables(customerAccessToken: token, addressId: id)
        )

        let envelope: GraphQLEnvelope<CustomerDefaultAddressUpdateData> = try await send(endpoint)

        if let userError = envelope.data?.customerDefaultAddressUpdate?.customerUserErrors.first {
            throw AddressError.apiError(userError.message)
        }
    }


    private func send<T: Decodable, V: Encodable>(
        _ endpoint: AddressGraphQLEndpoint<V>
    ) async throws -> GraphQLEnvelope<T> {
        do {
            let envelope: GraphQLEnvelope<T> = try await networkClient.request(endpoint: endpoint)

            if let topLevelError = envelope.errors?.first {
                // Matches the two failure modes you hit in Postman:
                // "Access denied ... Requires valid customer access token." and "invalid id".
                if topLevelError.extensions?.code == "RESOURCE_NOT_FOUND" ||
                    topLevelError.message.lowercased().contains("invalid id") {
                    throw AddressError.notFound
                }
                if topLevelError.extensions?.code == "ACCESS_DENIED" {
                    throw AddressError.missingToken
                }
                throw AddressError.apiError(topLevelError.message)
            }

            return envelope
        } catch let error as AddressError {
            throw error
        } catch let error as NetworkError {
            throw AddressError.network(String(describing: error))
        } catch {
            throw AddressError.network(error.localizedDescription)
        }
    }
}

private extension AddressDraft {

    func toInputDTO() -> MailingAddressInputDTO {
        let nameParts = recipientName
            .trimmingCharacters(in: .whitespaces)
            .components(separatedBy: " ")

        return MailingAddressInputDTO(
            firstName: nameParts.first,
            lastName: nameParts.dropFirst().joined(separator: " "),
            address1: street,
            address2: apartment.isEmpty ? nil : apartment,
            city: city,
            country: country,
            zip: postalCode,
            phone: fullPhoneNumber.isEmpty ? nil : fullPhoneNumber
        )
    }
}
