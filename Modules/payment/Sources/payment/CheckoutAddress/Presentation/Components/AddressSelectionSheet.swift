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
    var addresses: [Address]
    var onSelect: ((Address) -> Void)?
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
                .foregroundColor(DS.textSec)
            
            VStack(spacing: 8) {
                Text("No Saved Addresses")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(DS.textPri)
                
                Text("Add a new address to speed up your checkout process.")
                    .font(.system(size: 14))
                    .foregroundColor(DS.textSec)
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
        .background(DS.background)
    }
    
    private var populatedListView: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(addresses) { address in
                    Button(action: {
                        onSelect?(address)
                        dismiss()
                    }) {
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 22))
                                .foregroundColor(DS.red)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(address.title)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(DS.textPri)
                                
                                Text(address.details)
                                    .font(.system(size: 14))
                                    .foregroundColor(DS.textSec)
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer()
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(DS.cardBG)
                        .cornerRadius(12)
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(DS.border, lineWidth: 1)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
        }
        .background(DS.background)
    }
}
