//
//  AIAssistantFloatingButton.swift
//  Shopify
//
//  Created by Kiro on 07/07/2026.
//

import SwiftUI
import AIAssistant
import Common

struct AIAssistantFloatingButton: View {
    let onProductSelected: (ShopifyProduct) -> Void

    @State private var showChat = false
    @State private var showDrawer = false
    @State private var selectedFeature: AIFeature? = nil

    init(onProductSelected: @escaping (ShopifyProduct) -> Void = { _ in }) {
        self.onProductSelected = onProductSelected
    }
    
    var body: some View {
        ZStack {
            // Floating button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    // Main AI button
                    Button(action: {
                        showChat = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.indigo, Color.purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 60, height: 60)
                                .shadow(color: Color.indigo.opacity(0.4), radius: 8, x: 0, y: 4)
                            
                            Image(systemName: "sparkles")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.trailing, 16)
                    .padding(.bottom, 16)
                }
            }
        }
        // Chat fullscreen cover
        .fullScreenCover(isPresented: $showChat) {
            NavigationStack {
                ChatView(agent: AIAssistantKit.shared.shoppingAssistant) { product in
                    showChat = false
                    onProductSelected(product)
                }
                    .navigationTitle("AI Shopping Assistant")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(action: { showChat = false }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .font(.title3)
                            }
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: { 
                                showChat = false
                                showDrawer = true
                            }) {
                                Image(systemName: "wand.and.stars")
                                    .foregroundColor(.indigo)
                            }
                        }
                    }
            }
        }
        // Drawer sheet
        .sheet(isPresented: $showDrawer) {
            AIFeaturesDrawer(selectedFeature: $selectedFeature)
        }
        // Feature detail view
        .fullScreenCover(item: $selectedFeature) { feature in
            NavigationStack {
                AIAssistantCoordinator(initialFeature: feature) { product in
                    selectedFeature = nil
                    onProductSelected(product)
                }
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(action: { selectedFeature = nil }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .font(.title3)
                            }
                        }
                    }
            }
        }
    }
}

struct AIFeaturesDrawer: View {
    @Binding var selectedFeature: AIFeature?
    @Environment(\.dismiss) var dismiss
    
    private let features: [AIFeature] = AIFeature.allCases
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(features, id: \.self) { feature in
                        Button(action: {
                            selectedFeature = feature
                            dismiss()
                        }) {
                            HStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(DS.red.opacity(0.12))
                                        .frame(width: 50, height: 50)
                                    
                                    Image(systemName: feature.icon)
                                        .font(.title3)
                                        .foregroundColor(DS.red)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(LocalizedStringKey(feature.rawValue))
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(DS.textPri)
                                    
                                    Text(LocalizedStringKey(feature.description))
                                        .font(.system(size: 13))
                                        .foregroundColor(DS.textSec)
                                        .lineLimit(2)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(DS.textSec)
                            }
                            .padding(.vertical, 8)
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(DS.cardBG)
                    }
                } header: {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("AI-Powered Features")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(DS.textPri)
                        
                        Text("Enhance your shopping experience with intelligent assistants")
                            .font(.subheadline)
                            .foregroundColor(DS.textSec)
                    }
                    .textCase(nil)
                    .padding(.bottom, 8)
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(DS.background.ignoresSafeArea())
            .navigationTitle("AI Assistant")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(DS.textSec)
                    }
                }
            }
        }
    }
}

// Helper extension for feature descriptions
extension AIFeature {
    var description: String {
        switch self {
        case .shoppingAssistant:
            return "Chat with AI to find products, get recommendations, and shop smarter"
        case .productComparison:
            return "Compare multiple products side-by-side with AI-powered insights"
        case .imageSearch:
            return "Upload an image to find similar products in our catalog"
        case .outfitGenerator:
            return "Get complete outfit suggestions based on your preferences"
        }
    }
}

// Make AIFeature Identifiable for sheet presentation
extension AIFeature: Identifiable {
    public var id: String { rawValue }
}

#Preview {
    AIAssistantFloatingButton()
}
