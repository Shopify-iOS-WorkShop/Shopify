//
//  CurrencyPickerView.swift
//  Settings — Presentation
//

import SwiftUI

public struct CurrencyPickerView: View {
    let rates: ExchangeRates
    @Binding var selected: String

    public init(rates: ExchangeRates, selected: Binding<String>) {
        self.rates = rates
        self._selected = selected
    }

    public var body: some View {
        List {
            Section("Base: \(rates.baseCurrency)") {
                ForEach(rates.availableCurrencies, id: \.self) { code in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(code)
                                .fontWeight(.medium)
                            if let rate = rates.rates[code] {
                                Text("1 \(rates.baseCurrency) = \(String(format: "%.4f", rate)) \(code)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }

                        Spacer()

                        if selected == code {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color(red: 233/255, green: 69/255, blue: 96/255))
                                .fontWeight(.semibold)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selected = code
                    }
                }
            }
        }
        .navigationTitle("Select Currency")
        .navigationBarTitleDisplayMode(.inline)
    }
}
