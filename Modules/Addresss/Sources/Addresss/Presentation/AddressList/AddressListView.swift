//
//  AddressListView.swift
//  Address
//
//  Created by Mina Nashaat on 05/07/2026.
//

import SwiftUI

public struct AddressListView: View {
    @Bindable var viewModel: AddressListViewModel
    @Environment(AddressCoordinator.self) private var coordinator

    @State private var pendingDelete: Address?

    public init(viewModel: AddressListViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                header

                if viewModel.isLoading && viewModel.addresses.isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                } else if viewModel.addresses.isEmpty {
                    emptyState
                } else {
                    ForEach(Array(viewModel.addresses.enumerated()), id: \.element.id) { index, address in
                        AddressCardView(
                            address: address,
                            icon: icon(for: address, index: index),
                            canDelete: viewModel.canDelete(address),
                            onEdit: {
                                coordinator.push(.addOrEdit(editing: address))
                            },
                            onDelete: {
                                guard viewModel.canDelete(address) else {
                                    viewModel.errorMessage = AddressError.cannotDeleteDefault.localizedDescription
                                    return
                                }
                                pendingDelete = address
                            },
                            onSelect: coordinator.onAddressSelected == nil
                                ? nil
                                : { coordinator.onAddressSelected?(address) },
                            onSetDefault: coordinator.onAddressSelected == nil
                                ? { Task { await viewModel.setDefault(address) } }
                                : nil
                        )
                    }

                    promoBanner
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 100)
        }
        .background(AddressDS.background)
        .overlay(alignment: .bottomTrailing) {
            addButton
        }
        .navigationTitle("My Addresses")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
//                Button {
//                    // Room for a future "sort / import from contacts" menu.
//                } label: {
//                    Image(systemName: "ellipsis")
//                        .foregroundStyle(AddressDS.textPri)
//                }
            }
        }
        .task {
            await viewModel.loadAddresses()
        }
        .alert(
            "Delete this address?",
            isPresented: Binding(
                get: { pendingDelete != nil },
                set: { if !$0 { pendingDelete = nil } }
            )
        ) {
            Button("Delete", role: .destructive) {
                if let address = pendingDelete {
                    Task { await viewModel.delete(address) }
                }
                pendingDelete = nil
            }
            Button("Cancel", role: .cancel) { pendingDelete = nil }
        } message: {
            Text("This can't be undone.")
        }
        .alert(
            "Something went wrong",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    private var header: some View {
        HStack {
            Text("SAVED LOCATIONS")
                .font(.caption.weight(.semibold))
                .foregroundStyle(AddressDS.textSec)
                .tracking(0.6)

            Spacer()

            if viewModel.addresses.count == 1 {
                Text("1 Address")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(AddressDS.red)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(AddressDS.red.opacity(0.12), in: Capsule())
            } else {
                Text("\(viewModel.addresses.count) Addresses")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(AddressDS.red)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(AddressDS.red.opacity(0.12), in: Capsule())
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "mappin.and.ellipse")
                .font(.system(size: 40))
                .foregroundStyle(AddressDS.lightGray)
            Text("No saved addresses yet")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(AddressDS.textSec)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }

    private var promoBanner: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(AddressDS.navy)
                .frame(height: 110)

            Text("Add your most frequented places for a faster checkout experience.")
                .font(.footnote.weight(.medium))
                .foregroundStyle(.white)
                .padding(16)
        }
    }

    private var addButton: some View {
        Button {
            coordinator.push(.addOrEdit(editing: nil))
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(AddressDS.red, in: Circle())
                .shadow(color: AddressDS.red.opacity(0.35), radius: 10, y: 4)
        }
        .padding(.trailing, 20)
        .padding(.bottom, 24)
    }

    private func icon(for address: Address, index: Int) -> String {
        if address.isDefault { return "house.fill" }
        return index % 2 == 0 ? "briefcase.fill" : "building.2.fill"
    }
}
