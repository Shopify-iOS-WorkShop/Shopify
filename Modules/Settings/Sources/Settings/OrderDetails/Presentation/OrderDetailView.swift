//
//  File.swift
//  
//
//  Created by Mazen Amr on 07/07/2026.
//

import SwiftUI
import Common
public struct OrderDetailView: View {
    let viewModel: OrderDetailViewModel
    
    public init(viewModel: OrderDetailViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).ignoresSafeArea()
            
            if viewModel.isLoading || (viewModel.order == nil && viewModel.errorMessage == nil) {
                ProgressView("Loading Order Details...")
            } else if let error = viewModel.errorMessage {
                ContentUnavailableView("Error", systemImage: "exclamationmark.triangle", description: Text(error))
            } else if let order = viewModel.order {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        OrderHeaderView(order: order)
                        OrderItemsView(items: order.lineItems, formatPrice: viewModel.formatPrice)
                        OrderAddressView(address: order.shippingAddress)
                        OrderSummaryView(order: order, formatPrice: viewModel.formatPrice)
                    }
                    .padding(.vertical)
                }
            }
        }
        .navigationTitle("Order Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadOrderDetails()
        }
    }
}
