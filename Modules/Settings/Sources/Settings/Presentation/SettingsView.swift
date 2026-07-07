//
//  SettingsView.swift
//  Settings — Presentation
//

import SwiftUI
import Addresss
import DependencyInjection

public struct SettingsView: View {
    @State var viewModel: SettingsViewModel
    @Environment(SettingsCoordinator.self) private var coordinator
    @State private var isShowingAddresses = false

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
                                .foregroundColor(.secondary)
                            Text("You're browsing as a guest")
                                .font(.headline)
                            Text("Sign in to access your orders, addresses, and saved preferences.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            Button {
                                viewModel.onSignIn?()
                            } label: {
                                Text("Sign In")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(Color(red: 233/255, green: 69/255, blue: 96/255))
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
                        ForEach(profile.recentOrders) { order in
                            OrderRowView(order: order)
                        }
                        NavigationLink("View All Orders", value: SettingsRoute.orderHistory)
                            .font(.subheadline)
                            .foregroundColor(Color(red: 233/255, green: 69/255, blue: 96/255))
                    }
                }

                if !viewModel.isGuest {
                    Section("Account") {
                        NavigationLink(value: SettingsRoute.editProfile) {
                            Label("Edit Profile", systemImage: "person.circle")
                        }
                        Button {
                            isShowingAddresses = true
                        } label: {
                            Label("Addresses", systemImage: "map")
                                .foregroundColor(.primary)
                        }
                        NavigationLink(value: SettingsRoute.orderHistory) {
                            Label("Order History", systemImage: "clock.arrow.2.circlepath")
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
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .disabled(viewModel.exchangeRates == nil)

                    if let rates = viewModel.exchangeRates {
                        let sample = rates.convert(100, to: viewModel.selectedCurrency) ?? 100
                        Text("100 \(rates.baseCurrency) ≈ \(viewModel.selectedCurrency) \(String(format: "%.2f", sample))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Section {
                    if viewModel.isGuest {
                        Button {
                            viewModel.onSignIn?()
                        } label: {
                            Label("Sign In", systemImage: "person.badge.plus")
                                .foregroundColor(Color(red: 233/255, green: 69/255, blue: 96/255))
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
            .sheet(isPresented: $isShowingAddresses) {
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
            OrderHistoryView(orders: viewModel.profile?.recentOrders ?? [])
        case .editProfile:
            EditProfilePlaceholderView()
        case .addresses:
            // Presented via the .sheet modifier instead — AddressFlowView owns its
            // own NavigationStack, so it can't be pushed onto this one.
            EmptyView()
        }
    }
}


private struct OrderHistoryView: View {
    let orders: [CustomerOrder]
    var body: some View {
        List(orders) { order in OrderRowView(order: order) }
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


private struct EditProfilePlaceholderView: View {
    var body: some View {
        ContentUnavailableView(
            "Coming Soon", systemImage: "person.circle",
            description: Text("Profile editing will be available here.")
        )
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct AddressesPlaceholderView: View {
    var body: some View {
        ContentUnavailableView(
            "Coming Soon", systemImage: "map",
            description: Text("Address management will be available here.")
        )
        .navigationTitle("Addresses")
        .navigationBarTitleDisplayMode(.inline)
    }
}
