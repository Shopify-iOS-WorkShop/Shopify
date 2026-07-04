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
    public init(viewModel: CheckoutAddressViewModel? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel ?? CheckoutAddressFactory.makeAddressViewModel())
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
                                Text("Fill out the form below.")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
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
                        .keyboardType(.numberPad)
                        .onChange(of: viewModel.mobileNumber) { _, newValue in
                            let filtered = newValue.filter { $0.isNumber }
                            if filtered != newValue { viewModel.mobileNumber = filtered }
                        }
                    HStack(spacing: 16) {
                        CustomInputField(title: "CITY", placeholder: "City", text: $viewModel.city)
                        CustomInputField(title: "STREET", placeholder: "Street name", text: $viewModel.street)
                    }
                }
                .padding(.horizontal, 20)
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
                .background(DS.red)
                .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(
            Color(UIColor.systemBackground)
                .shadow(color: Color.black.opacity(0.08), radius: 10, y: -4)
        )
        // Updated Alert Logic
        .alert("Save Changes?", isPresented: $viewModel.showUpdateAlert) {
            Button("Cancel", role: .cancel) {
                viewModel.revertAddressChanges()
            }
            Button("Save & Proceed") {
                Task {
                    let success = await viewModel.confirmAndSaveAddress()
                    if success {
                        coordinator.push(.payment)
                    }
                }
            }
        } message: {
            Text("You have modified your selected address. Do you want to save these changes to your profile before proceeding?")
        }
    }
}
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
