//
//  AddAddressView.swift
//  Address
//
//  Created by Mina Nashaat on 05/07/2026.
//

import SwiftUI

public struct AddAddressView: View {
    @Bindable var viewModel: AddAddressViewModel
    @Environment(AddressCoordinator.self) private var coordinator

    /// Called with the newly created/updated address so the caller (list
    /// screen or checkout flow) can update its own state without a refetch.
    var onSaved: ((Address) -> Void)?

    public init(viewModel: AddAddressViewModel, onSaved: ((Address) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onSaved = onSaved
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AddressMapPickerView(viewModel: viewModel)
                    .padding(.top, 12)

                VStack(alignment: .leading, spacing: 16) {
                    LabeledField(label: "Recipient Name", placeholder: "e.g. John Doe", text: $viewModel.draft.recipientName)

                    DialCodeField(dialCode: $viewModel.draft.dialCode, mobileNumber: $viewModel.draft.mobileNumber)

                    HStack(spacing: 12) {
                        LabeledField(label: "Country", placeholder: "United States", text: $viewModel.draft.country)
                        LabeledField(label: "City", placeholder: "New York", text: $viewModel.draft.city)
                    }

                    LabeledField(label: "Street Address", placeholder: "128 West 26th Street", text: $viewModel.draft.street)

                    HStack(spacing: 12) {
                        LabeledField(label: "Apt / Bldg", placeholder: "Floor 4", text: $viewModel.draft.apartment)
                        LabeledField(label: "Postal Code", placeholder: "10001", text: $viewModel.draft.postalCode, keyboardType: .numberPad)
                    }

                    if viewModel.isAddressVerified {
                        VerifiedBanner()
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 110)
        }
        .background(AddressDS.background)
        .safeAreaInset(edge: .bottom) {
            saveButton
        }
        .navigationTitle(viewModel.draft.isEditing ? "Edit Address" : "Add Address")
        .navigationBarTitleDisplayMode(.inline)
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
        .onChange(of: viewModel.savedAddress) { _, newValue in
            guard let newValue else { return }
            onSaved?(newValue)
            coordinator.pop()
        }
    }

    private var saveButton: some View {
        Button {
            Task { await viewModel.save() }
        } label: {
            HStack {
                if viewModel.isSaving {
                    ProgressView().tint(.white)
                } else {
                    Text("Save Address")
                        .font(.headline)
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(AddressDS.red, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: AddressDS.red.opacity(0.3), radius: 10, y: 5)
        }
        .disabled(viewModel.isSaving)
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .background(AddressDS.background)
    }
}
