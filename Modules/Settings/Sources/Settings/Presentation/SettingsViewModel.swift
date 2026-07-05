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
    public private(set) var exchangeRates: ExchangeRates?
    public private(set) var isLoadingProfile: Bool = false
    public private(set) var isLoadingRates: Bool = false
    public private(set) var errorMessage: String?

    /// Selected display currency, persisted in UserDefaults.
    @ObservationIgnored
    @AppStorage("settings_selectedCurrency")
    public var selectedCurrency: String = "USD"

    /// 0 = system, 1 = light, 2 = dark — persisted in UserDefaults.
    /// ContentView reads this same key via @AppStorage, so the entire app
    /// reacts the instant this value changes. No delay.
    @ObservationIgnored
    @AppStorage("settings_colorScheme")
    public var colorSchemeRaw: Int = 0

    public var preferredColorScheme: ColorScheme? {
        switch colorSchemeRaw {
        case 1: return .light
        case 2: return .dark
        default: return nil
        }
    }

    public var colorSchemeLabel: String {
        switch colorSchemeRaw {
        case 1: return "Light"
        case 2: return "Dark"
        default: return "System"
        }
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

    // MARK: - Init

    public init(
        getProfileUseCase: GetCustomerProfileUseCase,
        getExchangeRatesUseCase: GetExchangeRatesUseCase,
        sessionStore: SessionProviding
    ) {
        self.getProfileUseCase       = getProfileUseCase
        self.getExchangeRatesUseCase = getExchangeRatesUseCase
        self.sessionStore            = sessionStore
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
        if case .success(let rates) = result { exchangeRates = rates }
    }

    /// Persists the theme choice. ContentView's @AppStorage binding for the same
    /// key fires immediately, applying the color scheme to the whole app.
    public func setColorScheme(_ raw: Int) {
        colorSchemeRaw = raw
    }

    public func requestSignOut() { isShowingSignOutConfirmation = true  }
    public func cancelSignOut()  { isShowingSignOutConfirmation = false }

    public func convert(amount: Double) -> String {
        guard let rates = exchangeRates,
              let converted = rates.convert(amount, to: selectedCurrency) else {
            return String(format: "%.2f", amount)
        }
        return "\(selectedCurrency) \(String(format: "%.2f", converted))"
    }
}
