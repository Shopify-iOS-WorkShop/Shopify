//
//  File.swift
//  
//
//  Created by Mazen Amr on 03/07/2026.
//

import Foundation
import SwiftUI
import Common

struct AddressSelectionSheet: View {
    var addresses: [MockAddress]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Group {
                if addresses.isEmpty {
                    emptyStateView
                } else {
                    populatedListView
                }
            }
            .navigationTitle("Select Address")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(DS.red)
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "map.circle")
                .font(.system(size: 72, weight: .light))
                .foregroundColor(Color(.systemGray3))
            
            VStack(spacing: 8) {
                Text("No Saved Addresses")
                    .font(.system(size: 20, weight: .bold))
                
                Text("Add a new address to speed up your checkout process.")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            Button(action: {
                dismiss()
            }) {
                Text("Add New Address")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(DS.red)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
    }
    
    private var populatedListView: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(addresses) { address in
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 22))
                                .foregroundColor(DS.red)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(address.title)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                Text(address.details)
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer()
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
        }
    }
}
