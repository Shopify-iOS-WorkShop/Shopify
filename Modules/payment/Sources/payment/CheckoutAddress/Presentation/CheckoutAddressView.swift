//
//  File.swift
//  
//
//  Created by Mazen Amr on 03/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct MockAddress: Identifiable {
    public let id = UUID()
    public let title: String
    public let details: String
}

public struct CheckoutAddressView: View {
    @State private var recipientName: String = ""
    @State private var mobileNumber: String = ""
    @State private var city: String = ""
    @State private var street: String = ""
    
    @State private var showingAddressSheet: Bool = false
    @State private var savedAddresses: [MockAddress] = [
         MockAddress(title: "Home Address", details: "123 Premium Lane, Luxury Heights\nNew York, NY 10001"),
         MockAddress(title: "Work Address", details: "456 Corporate Blvd, Suite 200\nNew York, NY 10002")
    ]
    
    public init() {}

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
                        if !savedAddresses.isEmpty {
                            Button("Change") {
                                showingAddressSheet = true
                            }
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(DS.red)
                        }
                    }
                    
                    if let currentAddress = savedAddresses.first {
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
                            Button(action: {
                                
                            }) {
                                Text("Add")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(DS.red)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)

                VStack(spacing: 16) {
                    CustomInputField(title: "RECIPIENT NAME", placeholder: "e.g. Johnathan Doe", text: $recipientName)
                    CustomInputField(title: "MOBILE NUMBER", placeholder: "+2 (___) ___-____", text: $mobileNumber)
                        .keyboardType(.numberPad)
                        .onChange(of: mobileNumber) { _, newValue in
                            let filtered = newValue.filter { $0.isNumber }
                            if filtered != newValue { mobileNumber = filtered }
                        }
                    HStack(spacing: 16) {
                        CustomInputField(title: "CITY", placeholder: "City", text: $city)
                        CustomInputField(title: "STREET", placeholder: "Street name", text: $street)
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
            AddressSelectionSheet(addresses: savedAddresses)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
    
    private var bottomPaymentButton: some View {
            VStack {
                Button(action: {}) {
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
        }
}
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
