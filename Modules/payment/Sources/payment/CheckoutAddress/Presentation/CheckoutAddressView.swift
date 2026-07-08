//
//  File.swift
//  
//
//  Created by Mazen Amr on 03/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct CheckoutAddressView: View {
    @StateObject private var viewModel: CheckoutAddressViewModel
    @Environment(CheckoutAddressCoordinator.self) private var coordinator
    
    @State private var showingAddressSheet: Bool = false
    
    @MainActor
    public init(viewModel: CheckoutAddressViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                CheckoutStepper(currentStep: .address)
                    .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Shipping Address")
                            .font(.system(size: 18, weight: .bold))
                        Spacer()
                        if !viewModel.savedAddresses.isEmpty {
                            Button("Change") {
                                showingAddressSheet = true
                            }
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(DS.red)
                        }
                    }
                    
                    if let currentAddress = viewModel.selectedAddress {
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "house")
                                .foregroundColor(DS.red)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(currentAddress.title).fontWeight(.semibold)
                                Text(currentAddress.details)
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    } else {
                        HStack(alignment: .center, spacing: 12) {
                            Image(systemName: "map.circle")
                                .font(.system(size: 32))
                                .foregroundColor(Color(.systemGray3))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("No Saved Addresses")
                                    .fontWeight(.semibold)
                                Button(action: {
                                    coordinator.onAddNewAddressRequested?()
                                }) {
                                    Text("Add a new address")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(DS.red)
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)

                VStack(spacing: 16) {
                    CustomInputField(title: "RECIPIENT NAME", placeholder: "e.g. Johnathan Doe", text: $viewModel.recipientName)
                    CustomInputField(title: "MOBILE NUMBER", placeholder: "+2 (___) ___-____", text: $viewModel.mobileNumber)
                        .keyboardType(.phonePad)
                    HStack(spacing: 16) {
                        CustomInputField(title: "CITY", placeholder: "City", text: $viewModel.city)
                        CustomInputField(title: "STREET", placeholder: "Street name", text: $viewModel.street)
                    }
                }
                .padding(.horizontal, 20)
                .disabled(viewModel.selectedAddress == nil)
                .opacity(viewModel.selectedAddress == nil ? 0.5 : 1.0)
            }
        }
        .onTapGesture { UIApplication.shared.endEditing() }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) { bottomPaymentButton }
        .sheet(isPresented: $showingAddressSheet) {
            AddressSelectionSheet(addresses: viewModel.savedAddresses) { selected in
                viewModel.selectAddress(selected)
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .task {
            await viewModel.loadAddresses()
        }
    }
    
    private var bottomPaymentButton: some View {
        VStack {
            Button(action: {
                if viewModel.prepareForCheckout() {
                    let nameParts = viewModel.recipientName.trimmingCharacters(in: .whitespaces).components(separatedBy: " ")
                    let firstName = nameParts.first ?? ""
                    let lastName = nameParts.dropFirst().joined(separator: " ")
                    
                    coordinator.selectedAddress = CheckoutAddress(
                        address1: viewModel.street,
                        city: viewModel.city,
                        country: viewModel.country,
                        firstName: firstName,
                        lastName: lastName,
                        phone: viewModel.mobileNumber
                    )
                    coordinator.push(.payment)
                }
            }) {
                HStack(spacing: 8) {
                    Text("Proceed to Payment")
                        .font(.system(size: 18, weight: .semibold))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(viewModel.selectedAddress == nil ? Color.gray : DS.red)
                .cornerRadius(12)
            }
            .primaryButtonStyle()
            .disabled(viewModel.selectedAddress == nil)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(
            DS.cardBG
                .shadow(color: .black.opacity(0.08), radius: 10, y: -4)
        )
        .background(DS.background.ignoresSafeArea())
        .alert("Save Changes?", isPresented: $viewModel.showUpdateAlert) {
            Button("Save & Proceed") {
                Task {
                    let success = await viewModel.confirmAndSaveAddress()
                    if success {
                        let nameParts = viewModel.recipientName.trimmingCharacters(in: .whitespaces).components(separatedBy: " ")
                        
                        coordinator.selectedAddress = CheckoutAddress(
                            address1: viewModel.street,
                            city: viewModel.city,
                            country: viewModel.country,
                            firstName: nameParts.first ?? "",
                            lastName: nameParts.dropFirst().joined(separator: " "),
                            phone: viewModel.mobileNumber
                        )
                        coordinator.push(.payment)
                    }
                }
            }
            Button("Cancel", role: .cancel) {
                viewModel.revertAddressChanges()
            }
        } message: {
            Text("You have modified your selected address. Do you want to save these changes to your profile before proceeding?")
        }
        .alert("Error", isPresented: Binding<Bool>(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            if let errorMessage = viewModel.errorMessage { Text(errorMessage) }
        }
    }
}
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
