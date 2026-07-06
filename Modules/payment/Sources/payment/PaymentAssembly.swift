//
//  File.swift
//  
//
//  Created by Mazen Amr on 06/07/2026.
//

import Foundation
import Swinject
import DependencyInjection
import ShopifyNetwork
import Auth
import Common

public class PaymentAssembly: DIAssembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        
        container.register(AddressRepositoryProtocol.self) { resolver in
            AddressRepository(
                client: resolver.resolve(GraphQLClientProtocol.self)!,
                authRepository: resolver.resolve(AuthRepositoryProtocol.self)!
            )
        }.inObjectScope(.container)
        
        container.register(PaymentRepositoryProtocol.self) { _ in
            PaymentRepository()
        }.inObjectScope(.container)
        
        container.register(GetSavedAddressesUseCaseProtocol.self) { resolver in
            GetSavedAddressesUseCase(
                repository: resolver.resolve(AddressRepositoryProtocol.self)!
            )
        }
        
        container.register(UpdateAddressUseCaseProtocol.self) { resolver in
            UpdateAddressUseCase(
                repository: resolver.resolve(AddressRepositoryProtocol.self)!
            )
        }
        
        container.register(PlaceOrderUseCaseProtocol.self) { resolver in
            PlaceOrderUseCase(
                repository: resolver.resolve(PaymentRepositoryProtocol.self)!
            )
        }
        
        container.register(CheckoutAddressViewModel.self) { resolver in
            MainActor.assumeIsolated {
                CheckoutAddressViewModel(
                    getAddressesUseCase: resolver.resolve(GetSavedAddressesUseCaseProtocol.self)!,
                    updateAddressUseCase: resolver.resolve(UpdateAddressUseCaseProtocol.self)!
                )
            }
        }
        
        container.register(PaymentMethodViewModel.self) { (
            resolver,
            cartItems: [CartItem],
            totalAmount: Double,
            deliveryFee: Double,
            address: CheckoutAddress,
            customerId: String
        ) in
            MainActor.assumeIsolated {
                PaymentMethodViewModel(
                    placeOrderUseCase: resolver.resolve(PlaceOrderUseCaseProtocol.self)!,
                    cartItems: cartItems,
                    totalAmount: totalAmount,
                    deliveryFee: deliveryFee,
                    address: address,
                    customerId: customerId
                )
            }
        }
    }
}
