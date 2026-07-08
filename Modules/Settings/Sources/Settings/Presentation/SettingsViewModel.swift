//
//  SettingsViewModel.swift
//  Settings — Presentation
//

import SwiftUI
import Observation
import Common

@Observable
public final class SettingsViewModel {

    // MARK: - State

    public private(set) var profile: CustomerProfile?
    public private(set) var isLoadingProfile: Bool = false
    public private(set) var isLoadingRates: Bool = false
    public private(set) var errorMessage: String?

    @ObservationIgnored
    public var makeOrderDetailViewModel: ((String) -> OrderDetailViewModel)!
    
    /// Proxy to the shared CurrencyStore — writing here updates every
    /// screen that observes CurrencyStore (Home, etc.) immediately.
    public var selectedCurrency: String {
        get { currencyStore.selectedCurrency }
        set { currencyStore.selectedCurrency = newValue }
    }

    /// Exchange rates are stored in CurrencyStore so Home can read them too.
    public var exchangeRates: ExchangeRates? {
        get { currencyStore.exchangeRates }
    }


    /// `true` when no customer session exists (user is browsing as guest).
    public var isGuest: Bool { sessionStore.current == nil }

    public var isShowingSignOutConfirmation: Bool = false

    /// Wired by ContentView — called when the guest taps "Sign In" in Settings.
    public var onSignIn: (() -> Void)?

    // MARK: - Dependencies

    private let getProfileUseCase: GetCustomerProfileUseCase
    private let getExchangeRatesUseCase: GetExchangeRatesUseCase
    private let sessionStore: SessionProviding
    public let currencyStore: CurrencyStore

    // MARK: - Init

    public init(
        getProfileUseCase: GetCustomerProfileUseCase,
        getExchangeRatesUseCase: GetExchangeRatesUseCase,
        sessionStore: SessionProviding,
        currencyStore: CurrencyStore
    ) {
        self.getProfileUseCase       = getProfileUseCase
        self.getExchangeRatesUseCase = getExchangeRatesUseCase
        self.sessionStore            = sessionStore
        self.currencyStore           = currencyStore
    }

    // MARK: - Lifecycle

    @MainActor
    public func onAppear() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.loadProfile() }
            group.addTask { await self.loadExchangeRates() }
        }
    }

    // MARK: - Actions

    @MainActor
    public func loadProfile() async {
        guard !isGuest else { return }   // guests have no Shopify profile
        isLoadingProfile = true
        errorMessage     = nil
        let result = await getProfileUseCase.execute()
        isLoadingProfile = false
        switch result {
        case .success(let p): profile      = p
        case .failure(let e): errorMessage = e.localizedDescription
        }
    }

    @MainActor
    public func loadExchangeRates() async {
        isLoadingRates = true
        let result = await getExchangeRatesUseCase.execute()
        isLoadingRates = false
        // Store rates in CurrencyStore so Home can do conversions too
        if case .success(let rates) = result {
            currencyStore.exchangeRates = rates
        }
    }

    public func requestSignOut() { isShowingSignOutConfirmation = true  }
    public func cancelSignOut()  { isShowingSignOutConfirmation = false }

    public func convert(amount: Double) -> String {
        currencyStore.convert(amount)
    }
}
