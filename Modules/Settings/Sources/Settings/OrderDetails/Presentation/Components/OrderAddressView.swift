//
//  File.swift
//  
//
//  Created by Mazen Amr on 07/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct OrderAddressView: View {
    let address: OrderAddress?
    
    public init(address: OrderAddress?) {
        self.address = address
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Shipping Address")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                if let address = address {
                    Text("\(address.firstName) \(address.lastName)")
                        .fontWeight(.medium)
                    Text(address.address1)
                    Text("\(address.city), \(address.country)")
                    Text(address.phone)
                } else {
                    Text("No shipping address provided.")
                        .foregroundColor(DS.textSec)
                }
            }
            .font(.subheadline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(DS.cardBG)
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}
