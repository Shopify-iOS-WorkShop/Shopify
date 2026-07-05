//
//  SearchFilterSheet.swift
//  search
//

import SwiftUI

struct SearchFilterSheet: View {
    @Binding var filter: SearchFilter
    let availableVendors: [String]
    let onApply: () -> Void
    let onReset: () -> Void

    var body: some View {
        NavigationView {
            List {
                // MARK: Sort
                Section("Sort By") {
                    ForEach(SearchSortOption.allCases) { option in
                        HStack {
                            Text(option.rawValue)
                                .foregroundColor(.primary)
                            Spacer()
                            if filter.sortBy == option {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.pocketPink)
                                    .fontWeight(.semibold)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture { filter.sortBy = option }
                    }
                }

                // MARK: Availability
                Section("Availability") {
                    Toggle(isOn: $filter.onlyAvailable) {
                        Text("In Stock Only")
                    }
                    .tint(.pocketPink)
                }

                // MARK: Vendor
                if !availableVendors.isEmpty {
                    Section("Brand") {
                        // "All" option
                        HStack {
                            Text("All Brands")
                                .foregroundColor(.primary)
                            Spacer()
                            if filter.vendor == nil {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.pocketPink)
                                    .fontWeight(.semibold)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture { filter.vendor = nil }

                        ForEach(availableVendors, id: \.self) { vendor in
                            HStack {
                                Text(vendor)
                                    .foregroundColor(.primary)
                                Spacer()
                                if filter.vendor == vendor {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.pocketPink)
                                        .fontWeight(.semibold)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture { filter.vendor = vendor }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Filter & Sort")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        onReset()
                    }
                    .foregroundColor(filter.isActive ? .pocketPink : .secondary)
                    .disabled(!filter.isActive)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        onApply()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.pocketPink)
                }
            }
        }
    }
}
