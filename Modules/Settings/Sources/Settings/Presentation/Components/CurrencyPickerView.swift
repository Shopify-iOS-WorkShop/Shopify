//
//  CurrencyPickerView.swift
//  Settings — Presentation
//

import SwiftUI
import Common

/// Currency picker that reads and writes directly from/to the shared CurrencyStore.
/// Because CurrencyStore is @Observable, SwiftUI re-renders this view immediately
/// when `currencyStore.selectedCurrency` changes — so the checkmark appears
/// instantly on tap without any navigation required.
public struct CurrencyPickerView: View {
    let rates: ExchangeRates
    /// The shared store is observed directly — no @Binding needed.
    @State var currencyStore: CurrencyStore
    @Environment(\.colorScheme) private var colorScheme

    public init(rates: ExchangeRates, currencyStore: CurrencyStore) {
        self.rates = rates
        self._currencyStore = State(wrappedValue: currencyStore)
    }

    @State private var searchText = ""

    public var body: some View {
        List {
            Section("Base: \(rates.baseCurrency)") {
                ForEach(filteredCurrencies, id: \.self) { code in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(code)
                                .fontWeight(.medium)
                                .foregroundColor(colorScheme == .dark ? .black : .primary)
                            if let rate = rates.rates[code] {
                                Text("1 \(rates.baseCurrency) = \(String(format: "%.4f", rate)) \(code)")
                                    .font(.caption)
                                    .foregroundColor(colorScheme == .dark ? .black.opacity(0.6) : DS.textSec)
                            }
                        }

                        Spacer()

                        if currencyStore.selectedCurrency == code {
                            Image(systemName: "checkmark")
                                .foregroundColor(DS.red)
                                .fontWeight(.semibold)
                        }
                    }
                    .contentShape(Rectangle())
                    .listRowBackground(colorScheme == .dark ? Color.white : Color(UIColor.secondarySystemBackground))
                    .onTapGesture {
                        // Writing to @Observable property — SwiftUI tracks this
                        // and re-renders immediately, showing the checkmark at once.
                        currencyStore.selectedCurrency = code
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(colorScheme == .dark ? Color.white : DS.background)
        .searchable(text: $searchText, prompt: "Search Currency")
        .navigationTitle("Select Currency")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var filteredCurrencies: [String] {
        if searchText.isEmpty {
            return rates.availableCurrencies
        }
        return rates.availableCurrencies.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
}
