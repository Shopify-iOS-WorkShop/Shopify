//
//  SettingsView.swift
//  Settings — Presentation
//

import SwiftUI
import Addresss
import DependencyInjection
import Common

@MainActor
public struct SettingsView: View {
    @State var viewModel: SettingsViewModel
    @Environment(SettingsCoordinator.self) private var coordinator

    public init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack(path: Binding(
            get: { coordinator.path },
            set: { coordinator.path = $0 }
        )) {
            List {

                if !viewModel.isGuest {
                    Section {
                        if viewModel.isLoadingProfile {
                            HStack { Spacer(); ProgressView(); Spacer() }.padding()
                        } else if let profile = viewModel.profile {
                            ProfileHeaderView(profile: profile)
                                .listRowInsets(EdgeInsets())
                        } else if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.callout)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    }
                    .listRowBackground(Color.clear)
                }

                if viewModel.isGuest {
                    Section {
                        VStack(spacing: 12) {
                            Image(systemName: "person.crop.circle.badge.questionmark")
                                .font(.system(size: 44))
                                .foregroundColor(DS.textSec)
                            Text("You're browsing as a guest")
                                .font(.headline)
                                .foregroundColor(DS.textPri)
                            Text("Sign in to access your orders, addresses, and saved preferences.")
                                .font(.subheadline)
                                .foregroundColor(DS.textSec)
                                .multilineTextAlignment(.center)
                            Button {
                                viewModel.onSignIn?()
                            } label: {
                                Text("Sign In")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(DS.red)
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                    }
                    .listRowBackground(Color.clear)
                }

                if !viewModel.isGuest,
                   let profile = viewModel.profile,
                   !profile.recentOrders.isEmpty {
                    Section("Recent Orders") {
                        ForEach(profile.recentOrders.prefix(3), id: \.id) { order in
                            NavigationLink(value: SettingsRoute.orderDetail(order: order)) {
                                OrderRowView(order: order, viewModel: viewModel)
                            }
                        }                        
                        NavigationLink("View All Orders", value: SettingsRoute.orderHistory)
                            .font(.subheadline)
                            .foregroundColor(DS.red)
                    }
                }

                if !viewModel.isGuest {
                    Section("Account") {
                        Button {
                            coordinator.isShowingAddresses = true
                        } label: {
                            Label("Addresses", systemImage: "map")
                                .foregroundColor(.primary)
                        }
                    }
                }

                Section("Appearance") {
                    Picker("Theme", selection: Binding(
                        get: { viewModel.colorSchemeRaw },
                        set: { viewModel.setColorScheme($0) }
                    )) {
                        Text("System").tag(0)
                        Text("Light").tag(1)
                        Text("Dark").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .listRowSeparator(.hidden)
                }

                Section("Currency") {
                    NavigationLink(value: SettingsRoute.currencyPicker) {
                        HStack {
                            Label("Display Currency", systemImage: "dollarsign.circle")
                            Spacer()
                            if viewModel.isLoadingRates {
                                ProgressView()
                            } else {
                                Text(viewModel.selectedCurrency)
                                    .foregroundColor(DS.textSec)
                            }
                        }
                    }
                    .disabled(viewModel.exchangeRates == nil)

                    if let rates = viewModel.exchangeRates {
                        let sample = rates.convert(100, to: viewModel.selectedCurrency) ?? 100
                        Text("100 \(rates.baseCurrency) ≈ \(viewModel.selectedCurrency) \(String(format: "%.2f", sample))")
                            .font(.caption)
                            .foregroundColor(DS.textSec)
                    }
                }

                Section {
                    if viewModel.isGuest {
                        Button {
                            viewModel.onSignIn?()
                        } label: {
                            Label("Sign In", systemImage: "person.badge.plus")
                                .foregroundColor(DS.red)
                        }
                    } else {
                        Button(role: .destructive) {
                            viewModel.requestSignOut()
                        } label: {
                            Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(DS.background)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .refreshable { await viewModel.onAppear() }
            .navigationDestination(for: SettingsRoute.self) { destinationView(for: $0) }
            .confirmationDialog(
                "Are you sure you want to sign out?",
                isPresented: Binding(
                    get: { viewModel.isShowingSignOutConfirmation },
                    set: { if !$0 { viewModel.cancelSignOut() } }
                ),
                titleVisibility: .visible
            ) {
                Button("Sign Out", role: .destructive) {
                    Task { await coordinator.onSignOut?() }
                }
                Button("Cancel", role: .cancel) { viewModel.cancelSignOut() }
            }

            .sheet(isPresented: Binding(
                get: { coordinator.isShowingAddresses },
                set: { coordinator.isShowingAddresses = $0 }
            )) {
                AddressFlowView(
                    listViewModel: DIContainer.shared.resolve(AddressListViewModel.self)!,
                    viewModelFactory: DIContainer.shared.resolve(AddressViewModelFactory.self)!
                )
            }
        }
        .task { await viewModel.onAppear() }
    }

    @ViewBuilder
    private func destinationView(for route: SettingsRoute) -> some View {
        switch route {
        case .currencyPicker:
            if let rates = viewModel.exchangeRates {
                CurrencyPickerView(
                    rates: rates,
                    currencyStore: viewModel.currencyStore
                )
            } else {
                ProgressView()
            }
        case .orderHistory:
            OrderHistoryView(
                orders: viewModel.profile?.recentOrders ?? [],
                viewModel: viewModel
            )
        case .addresses:
            AddressFlowView(
                listViewModel: DIContainer.shared.resolve(AddressListViewModel.self)!,
                viewModelFactory: DIContainer.shared.resolve(AddressViewModelFactory.self)!
            )

        case .orderDetail(let order):
            let detailViewModel = viewModel.makeOrderDetailViewModel(order.id)
            OrderDetailView(viewModel: detailViewModel)
        }
    }
}

private struct OrderHistoryView: View {
        let orders: [CustomerOrder]
        let viewModel: SettingsViewModel

        var body: some View {
            List(orders) { order in
                NavigationLink(value: SettingsRoute.orderDetail(order: order)) {
                    OrderRowView(order: order, viewModel: viewModel)
                }
            }
            .scrollContentBackground(.hidden)
            .background(DS.background)
            .navigationTitle("Order History")
            .navigationBarTitleDisplayMode(.inline)
            .overlay {
                if orders.isEmpty {
                    ContentUnavailableView(
                        "No Orders Yet",
                        systemImage: "bag",
                        description: Text("Your order history will appear here.")
                    )
                }
            }
        }
}
