//
//  AddressFlowView.swift
//  Address
//
//  Created by Mina Nashaat on 05/07/2026.
//

import SwiftUI

@MainActor
public struct AddressFlowView: View {
    @State private var coordinator = AddressCoordinator()

    let listViewModel: AddressListViewModel
    let viewModelFactory: AddressViewModelFactory
    let onAddressSelected: ((Address) -> Void)?

    public init(
        listViewModel: AddressListViewModel,
        viewModelFactory: AddressViewModelFactory,
        onAddressSelected: ((Address) -> Void)? = nil
    ) {
        self.listViewModel = listViewModel
        self.viewModelFactory = viewModelFactory
        self.onAddressSelected = onAddressSelected
    }

    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            AddressListView(viewModel: listViewModel)
                .navigationDestination(for: AddressRoute.self) { route in
                    destination(for: route)
                }
        }
        .environment(coordinator)
        .onAppear {
            coordinator.onAddressSelected = onAddressSelected
        }
    }

    @ViewBuilder
    private func destination(for route: AddressRoute) -> some View {
        switch route {
        case .list:
            AddressListView(viewModel: listViewModel)
        case .addOrEdit(let editing):
            AddAddressView(
                viewModel: viewModelFactory.makeAddAddressViewModel(editing: editing),
                onSaved: { address in
                    listViewModel.upsert(address)
                }
            )
        }
    }
}
