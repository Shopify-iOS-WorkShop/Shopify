//
//  AddressMapPickerView.swift
//  Address
//
//  Created by Mina Nashaat on 05/07/2026.
//

import SwiftUI
import MapKit

struct AddressMapPickerView: View {
    @Bindable var viewModel: AddAddressViewModel
    @FocusState private var searchFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            searchBar

            ZStack(alignment: .bottomTrailing) {
                Map(
                    coordinateRegion: $viewModel.region,
                    interactionModes: .all
                )
                .frame(height: 220)
                .overlay {
                    // Fixed center pin — dragging the map is how the user
                    // repositions it, mirroring the mockup's centered marker.
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(AddressDS.red)
                        .shadow(radius: 2, y: 2)
                }
                .onChange(of: viewModel.region.center.latitude) { _, _ in
                    scheduleReverseGeocode()
                }
                .onChange(of: viewModel.region.center.longitude) { _, _ in
                    scheduleReverseGeocode()
                }
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

                currentLocationButton
                    .padding(12)
            }
            .overlay(alignment: .topLeading) {
                if !viewModel.suggestions.isEmpty && searchFocused {
                    suggestionsList
                        .padding(.top, 4)
                }
            }
        }
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(AddressDS.textSec)

            TextField("Search for a street or area", text: $viewModel.searchText)
                .focused($searchFocused)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 3)
        .padding(.bottom, 10)
        .zIndex(1)
    }

    private var suggestionsList: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(viewModel.suggestions.prefix(5), id: \.self) { suggestion in
                Button {
                    viewModel.selectSuggestion(suggestion)
                    searchFocused = false
                } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(suggestion.title)
                            .font(.subheadline)
                            .foregroundStyle(AddressDS.textPri)
                        if !suggestion.subtitle.isEmpty {
                            Text(suggestion.subtitle)
                                .font(.caption)
                                .foregroundStyle(AddressDS.textSec)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                Divider()
            }
        }
        .background(Color.white, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 10, y: 4)
    }

    private var currentLocationButton: some View {
        Button {
            viewModel.useCurrentLocation()
        } label: {
            Group {
                if viewModel.isLocating {
                    ProgressView()
                } else {
                    Image(systemName: "location.fill")
                        .foregroundStyle(AddressDS.navy)
                }
            }
            .frame(width: 44, height: 44)
            .background(Color.white, in: Circle())
            .shadow(color: .black.opacity(0.12), radius: 6, y: 2)
        }
    }

    // Debounce so we don't reverse-geocode on every single map-pan frame.
    @State private var geocodeWorkItem: DispatchWorkItem?
    private func scheduleReverseGeocode() {
        geocodeWorkItem?.cancel()
        let coordinate = viewModel.region.center
        let workItem = DispatchWorkItem {
            Task { @MainActor in
                viewModel.movePin(to: coordinate)
            }
        }
        geocodeWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: workItem)
    }
}
