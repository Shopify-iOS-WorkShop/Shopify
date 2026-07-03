//
//  File.swift
//  
//
//  Created by Mazen Amr on 29/06/2026.
//

import Foundation
import SwiftUI

public struct FilterDrawerSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ProductListingViewModel
    
    public var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Price Range")) {
                    HStack {
                        TextField("Min", value: $viewModel.filterCriteria.minPrice, format: .number)
                            .keyboardType(.decimalPad)
                        Text("-")
                        TextField("Max", value: $viewModel.filterCriteria.maxPrice, format: .number)
                            .keyboardType(.decimalPad)
                    }
                }
                
                Section(header: Text("Availability")) {
                    Toggle("In Stock Only", isOn: $viewModel.filterCriteria.inStockOnly)
                }
                
                Section(header: Text("Brands")) {
                    ForEach(viewModel.availableVendors, id: \.self) { vendor in
                        Button(action: {
                            if viewModel.filterCriteria.selectedVendors.contains(vendor) {
                                viewModel.filterCriteria.selectedVendors.remove(vendor)
                            } else {
                                viewModel.filterCriteria.selectedVendors.insert(vendor)
                            }
                        }) {
                            HStack {
                                Text(vendor)
                                    .foregroundColor(DS.textPri)
                                Spacer()
                                if viewModel.filterCriteria.selectedVendors.contains(vendor) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(DS.red)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Clear") {
                        viewModel.clearFilters()
                    }
                    .foregroundColor(DS.textSec)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        viewModel.applyFilters()
                        dismiss()
                    }
                    .foregroundColor(DS.red)
                    .fontWeight(.bold)
                }
            }
        }
    }
}
