//
//  File.swift
//  
//
//  Created by Mazen Amr on 07/07/2026.
//

import Foundation
import Observation
import Common

@Observable
public final class OrderDetailViewModel {
    public private(set) var order: FullOrder?
    public private(set) var isLoading: Bool = false
    public private(set) var errorMessage: String?
    
    private let orderId: String
    private let getOrderDetailsUseCase: GetOrderDetailsUseCaseProtocol
    private let sessionStore: SessionProviding
    private let currencyStore: CurrencyStore
    public init(
        orderId: String,
        getOrderDetailsUseCase: GetOrderDetailsUseCaseProtocol,
        sessionStore: SessionProviding,
        currencyStore: CurrencyStore
    ) {
        self.orderId = orderId
        self.getOrderDetailsUseCase = getOrderDetailsUseCase
        self.sessionStore = sessionStore
        self.currencyStore = currencyStore
    }
    
    @MainActor
    public func loadOrderDetails() async {
        guard let token = sessionStore.current?.customerAccessToken else {
            errorMessage = "Please sign in to view order details."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            order = try await getOrderDetailsUseCase.execute(orderId: orderId, customerAccessToken: token)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    public func formatPrice(_ amount: Double) -> String {
        return currencyStore.convert(amount)
    }
}
