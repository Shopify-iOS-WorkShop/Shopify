//
//  CommonCatalogGridView.swift
//  Common
//
//  Created by Mina on 01/07/2026.
//

import SwiftUI

public struct CommonCatalogGridView: View {
    @StateObject private var viewModel: CatalogGridViewModel
    private let type: CatalogDisplayType
    public var onItemTapped: ((GridItemEntity) -> Void)?
    // Grid Setup for layout versatility
    private let columns = [
        GridItem(.adaptive(minimum: 100, maximum: 160), spacing: 16)
    ]
    
    public init(type: CatalogDisplayType, onItemTapped: ((GridItemEntity) -> Void)? = nil) {
            self.type = type
            self._viewModel = StateObject(wrappedValue: CatalogGridViewModel(type: type))
            self.onItemTapped = onItemTapped
    }
    
    public var body: some View {
            Group {
                if viewModel.isLoading {
                    ProgressView("Fetching Content...")
                } else if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Text("Oops! Something went wrong")
                            .font(.headline)
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(DS.textSec)
                        Button("Retry") {
                            Task { await viewModel.loadCatalogData() }
                        }
                        .padding()
                        .background(DS.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.items) { item in
                                Button {
                                    onItemTapped?(item)
                                } label: {
                                    CatalogCell(item: item)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle(type.navigationTitle)
            .task {
                await viewModel.loadCatalogData()
            }
        }
    
}

struct CatalogCell: View {
    let item: GridItemEntity
    
    var body: some View {
        VStack(spacing: 8) {
            if let url = item.imageURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 85, height: 85)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 85, height: 85)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(DS.lightGray, lineWidth: 1))
                    case .failure:
                        Image(systemName: "photo.circle.fill")
                            .resizable()
                            .foregroundColor(DS.textSec)
                            .frame(width: 85, height: 85)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            Text(item.name)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(DS.textPri)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
    }
}
